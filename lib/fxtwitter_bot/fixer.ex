defmodule FxtwitterBot.Fixer do
  @twitter_regex ~r/https?:\/\/(www\.|mobile\.)?twitter.com\/.+\/status/
  @twitter_replace ~r/https?:\/\/(www\.|mobile\.)?twitter.com/
  @twitter_fix "https://fxtwitter.com"

  @xtwitter_regex ~r/https?:\/\/(www\.|mobile\.)?x.com\/.+\/status/
  @xtwitter_replace ~r/https?:\/\/(www\.|mobile\.)?x.com/
  @xtwitter_fix "https://fixupx.com"

  @instagram_regex ~r/https?:\/\/(www\.)?instagram.com\/(p|reel)/
  @instagram_replace ~r/https?:\/\/(www\.)?instagram.com/
  @instagram_fix "https://ddinstagram.com"

  @tiktok_vm_regex ~r/https?:\/\/vm.tiktok.com/
  @tiktok_vm_fix "https://vm.dstn.to"

  @tiktok_regex ~r/https?:\/\/www.tiktok.com/
  @tiktok_fix "https://www.vxtiktok.com"

  @all_regex [
    @twitter_regex,
    @instagram_regex,
    @tiktok_regex,
    @tiktok_vm_regex,
    @xtwitter_regex
  ]
  @all_replaces [
    @twitter_replace,
    @instagram_replace,
    @tiktok_regex,
    @tiktok_vm_regex,
    @xtwitter_replace
  ]
  @all_fixes [@twitter_fix, @instagram_fix, @tiktok_fix, @tiktok_vm_fix, @xtwitter_fix]

  @regex_to_fix Enum.zip(@all_replaces, @all_fixes)

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
