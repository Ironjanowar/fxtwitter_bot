defmodule FxtwitterBot.Fixer do
  @twitter_regex ~r/https?:\/\/(www\.|mobile\.)?twitter.com/
  @twitter_fix "https://fxtwitter.com"

  @all_regex [@twitter_regex]
  @all_fixes [@twitter_fix]

  @regex_to_fix Enum.zip(@all_regex, @all_fixes)

  def maybe_fix(text) when is_binary(text) do
    if Enum.any?(@all_regex, &String.match?(text, &1)) do
      fix_text(text)
    else
      {:error, "No match"}
    end
  end

  def maybe_fix(_), do: {:error, "Not a string"}

  defp fix_text(text) do
    result =
      Enum.reduce(@regex_to_fix, text, fn {regex, fix}, text ->
        Regex.replace(regex, text, fix)
      end)

    {:ok, result}
  end
end
