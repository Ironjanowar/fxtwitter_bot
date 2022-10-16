defmodule FxtwitterBot do
  alias FxtwitterBot.RedisClient

  import ExGram.Dsl.Keyboard

  @twitter_regex ~r/https?:\/\/(www\.|mobile\.)?twitter.com/
  def maybe_fix(text) when is_binary(text) do
    if String.match?(text, @twitter_regex) do
      replace_urls(text)
    else
      {:error, "No match"}
    end
  end

  def maybe_fix(_), do: {:error, "Not a string"}

  def replace_urls(text) when is_binary(text) do
    result = Regex.replace(@twitter_regex, text, "https://fxtwitter.com")
    {:ok, result}
  end

  def replace_urls(_), do: {:error, "Not a string"}

  def help() do
    message = """
    This bots fixes Twitter links using [FixTweet](https://github.com/FixTweet/FixTweet), whenever it detects a Twitter link it will try to fix it

    Use /config to select if the bot should delete or answer the original message

    _Add the bot to any chat and give him administrator permissions so it can read all the messages_
    """

    opts = [parse_mode: "MarkdownV2"]

    {message, opts}
  end

  def about() do
    message = """
    _This bot was made by [@Ironjanowar](https://github.com/Ironjanowar) with ❤️_

    If you want to share some love and give a star ⭐️ to the repo [here it is](https://github.com/Ironjanowar/fxtwitter_bot)
    """

    opts = [parse_mode: "MarkdownV2"]

    {message, opts}
  end

  def config(chat_id) do
    delete_message? = get_config(chat_id)
    keyboard = generate_keyboard(delete_message?, chat_id)
    opts = [parse_mode: "MarkdownV2", reply_markup: keyboard]

    message =
      if delete_message? do
        """
        Message delete: *ENABLED*

        The bot will delete the message that it fixes
        """
      else
        """
        Message delete: *DISABLED*

        The bot will answer the message that it fixes
        """
      end

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

  def get_opts_from_config(deleted_message?, message_id) do
    if deleted_message? do
      []
    else
      [reply_to_message_id: message_id]
    end
  end

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
      add_from(message, from)
    else
      message
    end
  end

  defp add_from(message, %{id: id} = from) do
    name = get_name(from)

    """
    #{message}

    _Shared by_ [#{name}](tg://user?id=#{id})
    """
  end

  defp get_name(%{username: nil, first_name: first_name}), do: first_name
  defp get_name(%{username: username}), do: username
end
