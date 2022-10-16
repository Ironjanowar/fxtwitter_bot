defmodule FxtwitterBot.MessageFormatter do
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

  def config(true) do
    """
    Message delete: *ENABLED*

    The bot will delete the message that it fixes
    """
  end

  def config(false) do
    """
    Message delete: *DISABLED*

    The bot will answer the message that it fixes
    """
  end

  def add_from(message, from) do
    name = get_name(from)

    """
    Shared by #{name}

    #{message}
    """
  end

  defp get_name(%{username: nil, first_name: first_name}), do: first_name
  defp get_name(%{username: username}), do: "@#{username}"
end
