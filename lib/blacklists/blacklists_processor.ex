defmodule Puppies.BlacklistsProcessor do
  @moduledoc """
  The Blacklists context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.Blacklists.{Country}
  alias Puppies.{Accounts, Flags, Blacklists}

  # Check country
  defp get_user(user_id) do
    Accounts.User
    |> Repo.get_by(id: user_id)
  end

  def check_users_country_origin(user_id) do
    user =
      get_user(user_id)
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
               "type" => "high_risk_country"
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
  def check_user_email_for_banned_domain(user_id) do
    user = get_user(user_id)

    list = String.split(user.email, "@")
    domain = List.last(list)

    if Blacklists.domain_in_excluded_list(domain) &&
         !Flags.check_for_system_reported_flag(%{
           "offender_id" => user_id,
           "type" => "high_risk_domain"
         }) do
      Flags.create(%{
        system_reported: true,
        offender_id: user.id,
        reason: "User suspended. High risk domain: #{domain}"
      })

      Accounts.update_status(user, %{status: "suspended"})
    end
  end

  # check content
  def check_content_has_blacklisted_phrase(user, content, area) do
    blacklisted_content =
      Blacklists.get_blacklisted_items(Blacklists.Content)
      |> Enum.reduce([], fn content, acc ->
        [content.content | acc]
      end)

    Enum.each(blacklisted_content, fn word_or_phrase ->
      if String.contains?(content, word_or_phrase) do
        Flags.create(%{
          system_reported: true,
          offender_id: user.id,
          reason: "Blacklisted content in #{area}: #{word_or_phrase}",
          type: "blacklisted_content"
        })

        Accounts.update_status(user, %{status: "suspended"})
      end
    end)
  end

  # ip address
  def check_for_banned_ip_address(user, ip_address) do
    blacklisted_ips =
      Blacklists.get_blacklisted_items(Blacklists.IPAddress)
      |> Enum.reduce([], fn content, acc ->
        [content.ip_address | acc]
      end)

    Enum.each(blacklisted_ips, fn ip ->
      if ip == ip_address do
        Flags.create(%{
          system_reported: true,
          offender_id: user.id,
          reason: "Blacklisted IP Address: #{ip_address}",
          type: "blacklisted_ip"
        })

        Accounts.update_status(user, %{status: "suspended"})
      end
    end)
  end

  # Phone
  def check_for_banned_phone_number(user, phone_number) do
    phone_numbers =
      Blacklists.get_blacklisted_items(Blacklists.Phone)
      |> Enum.reduce([], fn content, acc ->
        [content.phone_number | acc]
      end)

    Enum.each(phone_numbers, fn phone ->
      if phone == phone_number do
        Flags.create(%{
          system_reported: true,
          offender_id: user.id,
          reason: "Blacklisted phone number: #{phone_number}",
          type: "blacklisted_phone_number"
        })

        Accounts.update_status(user, %{status: "suspended"})
      end
    end)
  end

  # check for duplicate content

  defp duplicate_content(new_content, other_users_content) do
    content_char_list = String.replace(new_content, " ", "") |> to_charlist
    other_content_char_list = String.replace(other_users_content, " ", "") |> to_charlist

    if Enum.sum(content_char_list) == Enum.sum(other_content_char_list) do
      true
    else
      false
    end
  end
end
