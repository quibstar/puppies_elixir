defmodule Puppies.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :email,
             :confirmed_at,
             :first_name,
             :last_name,
             :status,
             :phone_number,
             :is_seller,
             :business,
             :listings
           ]}
  schema "users" do
    field(:email, :string)
    field(:password, :string, virtual: true, redact: true)
    field(:hashed_password, :string, redact: true)
    field(:confirmed_at, :naive_datetime)
    field(:first_name, :string)
    field(:last_name, :string)
    field(:customer_id, :string)
    field(:status, :string, default: "active")
    field(:membership_end_date, :utc_datetime)
    field(:phone_number, :string)
    field(:phone_intl_format, :string)
    field(:visitor_id, :string)
    field(:terms_of_service, :boolean)
    field(:is_seller, :boolean, default: false)
    field(:approved_to_sell, :boolean, default: false)
    field(:reputation_level, :integer, default: 0)
    has_one(:business, Puppies.Businesses.Business)
    has_many(:listings, Puppies.Listings.Listing)
    has_many(:favorites, Puppies.Favorite, on_replace: :delete)
    many_to_many(:favorite_listings, Puppies.Listings.Listing, join_through: Puppies.Favorite)
    has_one(:user_location, Puppies.UserLocation, on_delete: :delete_all)
    has_one(:photo, Puppies.Photos.Photo)
    has_many(:threads, Puppies.Thread)

    timestamps()
  end

  @doc """
  A user changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [
      :email,
      :visitor_id,
      :password,
      :first_name,
      :last_name,
      :terms_of_service,
      :is_seller
    ])
    |> validate_email()
    |> validate_password(opts)
    |> unique_constraint(:visitor_id)
    |> validate_required([:first_name], message: "Please supply a first name")
    |> validate_required([:last_name], message: "Please supply a last name")
    |> validate_required([:terms_of_service], message: "You must agree to our terms of service")
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Puppies.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 8, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Puppies.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end

  def approved_changeset(user, attrs) do
    user
    |> cast(attrs, [:approved_to_sell])
  end

  def profile_changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name])
    |> cast_assoc(:user_location)
    |> validate_required([:first_name], message: "Please supply a first name")
    |> validate_required([:last_name], message: "Please supply a last name")
  end

  def user_update_reputation_level(user, attrs) do
    user
    |> cast(attrs, [:reputation_level])
  end

  def save_stripe_customer_id(user, attrs) do
    user
    |> cast(attrs, [:customer_id])
  end

  def save_phone_number(user, attrs) do
    user
    |> cast(attrs, [:phone_intl_format, :phone_number])
    |> validate_required([:phone_intl_format],
      message: "Missing international version, please try again"
    )
    |> validate_required([:phone_number], message: "Please supply a phone number")
  end
end
