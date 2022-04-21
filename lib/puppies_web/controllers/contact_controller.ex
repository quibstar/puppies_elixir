defmodule PuppiesWeb.ContactController do
  use PuppiesWeb, :controller

  alias Puppies.Contacts
  alias Puppies.Contacts.Contact

  def new(conn, _params) do
    changeset = Contacts.change_contact(%Contact{})
    render(conn, "new.html", changeset: changeset, page_title: "Contact Us - ")
  end

  def create(conn, %{"contact" => contact_params}) do
    %{"full_name" => full_name} = contact_params

    if full_name == "" do
      case Contacts.create_contact(contact_params) do
        {:ok, _} ->
          conn
          |> put_flash(:info, "We got it, be in contact soon.")
          |> redirect(to: Routes.contact_path(conn, :new))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    else
      conn
      |> put_flash(:info, "Hey Bot.")
      |> redirect(to: Routes.contact_path(conn, :new))
    end
  end
end
