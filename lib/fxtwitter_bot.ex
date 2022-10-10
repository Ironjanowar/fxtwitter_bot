defmodule FxtwitterBot do
  @twitter_url "twitter.com"
  def maybe_fix(text) when is_binary(text) do
    with {:ok, _} <- contains_twitter_url?(text) do
      replace_urls(text)
    end
  end

  def maybe_fix(_), do: {:error, "Not a string"}

  def contains_twitter_url?(text) when is_binary(text) do
    if String.contains?(text, @twitter_url) do
      {:ok, text}
    else
      {:error, "No urls"}
    end
  end

  def contains_twitter_url?(_), do: {:error, "Not a string"}

  def replace_urls(text) when is_binary(text) do
    result = String.replace(text, @twitter_url, "fxtwitter.com")
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
