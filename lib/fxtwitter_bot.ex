defmodule FxtwitterBot do
  alias FxtwitterBot.{MessageFormatter, RedisClient}

  import ExGram.Dsl.Keyboard

  alias __MODULE__.Fixer

  defdelegate maybe_fix(text), to: Fixer

  def config(chat_id) do
    delete_message? = get_config(chat_id)
    keyboard = generate_keyboard(delete_message?, chat_id)
    opts = [parse_mode: "MarkdownV2", reply_markup: keyboard]

    message = MessageFormatter.config(delete_message?)

    {message, opts}
  end

  defp get_config(chat_id) do
    case RedisClient.get(chat_id) do
      {:ok, "true"} ->
        true

      {:ok, "false"} ->
        false

      {:ok, nil} ->
        RedisClient.insert(chat_id, false)
        false
    end
  end

  defp generate_keyboard(delete_message?, id) do
    {text, data} =
      if delete_message? do
        {"Disable", "#{id}:disable"}
      else
        {"Enable", "#{id}:enable"}
      end

    keyboard :inline do
      row do
        button(text, callback_data: data)
      end
    end
  end

  def change_config(data) do
    [chat_id, config] = String.split(data, ":")
    config = config_to_boolean(config)
    RedisClient.insert(chat_id, config)
    config(chat_id)
  end

  defp config_to_boolean("enable"), do: true
  defp config_to_boolean("disable"), do: false

  def get_opts_from_config(deleted_message?, message_id, message_replied) do
    if deleted_message? do
      maybe_reply_to_message_id(message_replied)
    else
      [reply_to_message_id: message_id]
    end
  end

  defp maybe_reply_to_message_id(%{message_id: message_id}) when not is_nil(message_id),
    do: [reply_to_message_id: message_id]

  defp maybe_reply_to_message_id(_), do: []

  def maybe_delete_message(chat_id, message_id) do
    case RedisClient.get(chat_id) do
      {:ok, "true"} ->
        ExGram.delete_message(chat_id, message_id) |> handle_delete_message()

      {:ok, "false"} ->
        false

      {:ok, nil} ->
        RedisClient.insert(chat_id, false)
        false
    end
  end

  defp handle_delete_message({:ok, true}), do: true
  defp handle_delete_message(_), do: false

  def maybe_add_from(deleted_message?, message, from) do
    if deleted_message? do
      MessageFormatter.add_from(message, from)
    else
      message
    end
  end
end
