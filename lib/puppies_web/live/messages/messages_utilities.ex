defmodule PuppiesWeb.MessageUtilities do
  def unread_message_count(user, messages) do
    Enum.reduce(messages, 0, fn message, acc ->
      if !message.read && message.sent_by != user.id do
        acc + 1
      else
        acc
      end
    end)
  end

  def add_class(sent_by, user_id) do
    if sent_by == user_id do
      "flex-row-reverse"
    else
      ""
    end
  end

  def current_thread_class(current_thread_id, thread_id) do
    if current_thread_id == thread_id do
      "border-primary-500"
    else
      ""
    end
  end

  def last_message(messages) do
    message = List.first(messages)
    message.message
  end

  def last_message_date(messages) do
    message = List.first(messages)
    message.updated_at
  end

  def is_read(read) do
    if read do
      "stroke-green-500"
    else
      "stroke-gray-300"
    end
  end

  def business_or_user_name(receiver) do
    if Map.has_key?(receiver, :business) && !is_nil(receiver.business) do
      receiver.business.name
    else
      [receiver.first_name, " ", String.first(receiver.last_name)]
    end
  end

  def check_date(list, idx, inserted_at) do
    idx = idx - 1
    res = Enum.fetch(list, idx)

    case res do
      :error ->
        true

      {:ok, message} ->
        [inserted_at.year, inserted_at.month, inserted_at.day] != [
          message.inserted_at.year,
          message.inserted_at.month,
          message.inserted_at.day
        ]
    end
  end
end
