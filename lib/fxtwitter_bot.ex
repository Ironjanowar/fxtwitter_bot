defmodule FxtwitterBot do
  @twitter_regex ~r/https?:\/\/(www\.)?twitter.com/
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
    This bots fixes Twitter links using [FixTweet](https://github.com/FixTweet/FixTweet)

    Add the bot to any chat and give him administrator permissions so it can read all the messages.

    Whenever it detects a Twitter link it will try to fix it.
    """

    opts = [parse_mode: "Markdown"]

    {message, opts}
  end

  def about() do
    message = """
    __This bot was made by [@Ironjanowar](https://github.com/Ironjanowar) with ❤️__

    If you want to share some love and give a star ⭐️ to the repo [here it is](https://github.com/Ironjanowar/fxtwitter_bot)
    """

    opts = [parse_mode: "Markdown"]

    {message, opts}
  end
end
