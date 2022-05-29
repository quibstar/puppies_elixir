defmodule Puppies.BlacklistsProcessor do
  @moduledoc """
  The Blacklists context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.Blacklists.{Country}
  alias Puppies.{Accounts, Flags, Blacklists}

  # Check country

  def check_users_country_origin(user_id) do
    user =
      Accounts.User
      |> Repo.get_by(id: user_id)
      |> Repo.preload(:ip_addresses)

    if user.status == "active" do
      selected = Repo.all(from(c in Country, where: c.selected == true))

      map =
        Enum.reduce(selected, %{}, fn country, acc ->
          Map.put(acc, country.code, country.code)
        end)

      Enum.each(user.ip_addresses, fn x ->
        if Map.has_key?(map, x.country_code) &&
             !Flags.check_for_system_reported_flag(%{
               "offender_id" => user_id,
               "type" => "blacklisted_country"
             }) do
          Flags.create(%{
            system_reported: true,
            offender_id: user.id,
            reason: "User suspended. High risk country: #{x.country_name}"
          })

          Accounts.update_status(user, %{status: "suspended"})
        end
      end)
    end
  end

  # Check domain/email
  def check_user_email_for_banned_domain(user_id, email) do
    list = String.split(email, "@")
    domain = List.last(list)

    if Blacklists.domain_in_excluded_list(domain) &&
         !Flags.check_for_system_reported_flag(%{
           "offender_id" => user_id,
           "type" => "blacklisted_domain"
         }) do
      Flags.create(%{
        system_reported: true,
        offender_id: user_id,
        reason: "User suspended. High risk domain: #{domain}"
      })

      user = Accounts.get_user!(user_id)
      Accounts.update_status(user, %{status: "suspended"})
    end
  end

  # check content
  def check_content_has_blacklisted_phrase(user_id, content, area) do
    blacklisted_content = blacklisted_content()

    Enum.each(blacklisted_content, fn word_or_phrase ->
      if String.contains?(content, word_or_phrase) do
        Flags.create(%{
          system_reported: true,
          offender_id: user_id,
          reason: "Blacklisted content in #{area}: #{word_or_phrase}",
          type: "blacklisted_content"
        })

        user = Accounts.get_user!(user_id)
        Accounts.update_status(user, %{status: "suspended"})
      end
    end)
  end

  # ip address
  def check_for_banned_ip_address(user_id, ip_address) do
    blacklisted_ips = blacklisted_ips()

    Enum.each(blacklisted_ips, fn ip ->
      if ip == ip_address do
        Flags.create(%{
          system_reported: true,
          offender_id: user_id,
          reason: "Blacklisted IP Address: #{ip_address}",
          type: "blacklisted_ip"
        })

        user = Accounts.get_user!(user_id)
        Accounts.update_status(user, %{status: "suspended"})
      end
    end)
  end

  # Phone
  def check_for_banned_phone_number(user_id, phone_number) do
    phone_numbers = blacklisted_phone_numbers()

    Enum.each(phone_numbers, fn phone ->
      if phone == phone_number do
        Flags.create(%{
          system_reported: true,
          offender_id: user_id,
          reason: "Blacklisted phone number: #{phone_number}",
          type: "blacklisted_phone_number"
        })

        user = Accounts.get_user!(user_id)
        Accounts.update_status(user, %{status: "suspended"})
      end
    end)
  end

  # check for duplicate content
  def duplicate_content(new_content, other_users_content) do
    content_char_list = String.replace(new_content, " ", "") |> to_charlist
    other_content_char_list = String.replace(other_users_content, " ", "") |> to_charlist

    if Enum.sum(content_char_list) == Enum.sum(other_content_char_list) do
      true
    else
      false
    end
  end

  # check every user record
  def check_users_against_new_blacklist_country(country_code) do
    Repo.transaction(
      fn ->
        get_ip_data()
        |> Repo.stream()
        |> Stream.map(fn ip_data ->
          if ip_data.country_code == country_code do
            user = Accounts.get_user!(ip_data.user_id)

            Flags.create(%{
              system_reported: true,
              offender_id: user.id,
              reason: "Blacklisted country: #{ip_data.country_name}",
              type: "blacklisted_country"
            })

            Accounts.update_status(user, %{status: "suspended"})
          end
        end)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  def check_users_against_new_blacklist_domain(blacklisted_domain) do
    Repo.transaction(
      fn ->
        get_users()
        |> Repo.stream()
        |> Stream.map(fn user ->
          if String.contains?(user.email, blacklisted_domain) do
            Flags.create(%{
              system_reported: true,
              offender_id: user.id,
              reason: "Blacklisted domain: #{blacklisted_domain}",
              type: "blacklisted_domain"
            })

            Accounts.update_status(user, %{status: "suspended"})
          end
        end)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  def check_users_against_new_blacklist_ip(ip_address) do
    Repo.transaction(
      fn ->
        get_ip_data()
        |> Repo.stream()
        |> Stream.map(fn ip ->
          if ip.ip == ip_address do
            user = Accounts.get_user!(ip.user_id)

            Flags.create(%{
              system_reported: true,
              offender_id: user.id,
              reason: "Blacklisted ip address: #{ip_address}",
              type: "blacklisted_ip_address"
            })

            Accounts.update_status(user, %{status: "suspended"})
          end
        end)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  def check_against_new_blacklist_phone_number(phone_number, resource) do
    query =
      if resource == "user" do
        get_users()
      else
        get_businesses()
      end

    Repo.transaction(
      fn ->
        query
        |> Repo.stream()
        |> Stream.map(fn resource ->
          if resource.phone_number == phone_number do
            id =
              if Map.has_key?(resource, :user_id) do
                resource.user_id
              else
                resource.id
              end

            Flags.create(%{
              system_reported: true,
              offender_id: id,
              reason: "Blacklisted phone number: #{phone_number}",
              type: "blacklisted_phone_number"
            })

            user = Accounts.get_user!(id)
            Accounts.update_status(user, %{status: "suspended"})
          end
        end)
        |> Stream.run()
      end,
      timeout: :infinity
    )
  end

  def check_users_listings_or_business_against_new_blacklist_content(word_or_phrase, schema, area) do
    query = from(l in schema)

    Repo.transaction(fn ->
      query
      |> Repo.stream()
      |> Stream.map(fn resource ->
        if String.contains?(resource.description, word_or_phrase) do
          Flags.create(%{
            system_reported: true,
            offender_id: resource.user_id,
            reason: "Blacklisted content in #{area}: #{word_or_phrase}",
            type: "blacklisted_content"
          })

          user = Accounts.get_user!(resource.user_id)
          Accounts.update_status(user, %{status: "suspended"})
        end
      end)
      |> Stream.run()
    end)
  end

  # private

  defp get_users() do
    from(u in Puppies.Accounts.User)
  end

  defp get_businesses() do
    from(b in Puppies.Businesses.Business)
  end

  defp get_ip_data() do
    from(ip in Puppies.IPDatum)
  end

  # blacklisted content
  defp blacklisted_content() do
    Blacklists.get_all_blacklisted_items(Blacklists.Content)
    |> Enum.reduce([], fn content, acc ->
      [content.content | acc]
    end)
  end

  defp blacklisted_ips() do
    Blacklists.get_all_blacklisted_items(Blacklists.IPAddress)
    |> Enum.reduce([], fn content, acc ->
      [content.ip_address | acc]
    end)
  end

  defp blacklisted_phone_numbers() do
    Blacklists.get_all_blacklisted_items(Blacklists.Phone)
    |> Enum.reduce([], fn content, acc ->
      [content.phone_number | acc]
    end)
  end
end
