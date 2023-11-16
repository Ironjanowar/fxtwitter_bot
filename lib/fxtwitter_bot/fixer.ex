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
  @tiktok_vm_toggle_regex ~r/(?<url>https?:\/\/vm.dstn.to\/[^\s\/]+)(?<video>\/video.mp4)?/
  @tiktok_vm_fix "https://vm.dstn.to"

  @tiktok_regex ~r/https?:\/\/www.tiktok.com/
  @tiktok_fix "https://www.vxtiktok.com"

  @all_regex %{
    twitter: @twitter_regex,
    instagram: @instagram_regex,
    tiktok: @tiktok_regex,
    tiktok_vm: @tiktok_vm_regex,
    xtwitter: @xtwitter_regex
  }
  @all_replaces %{
    twitter: @twitter_replace,
    instagram: @instagram_replace,
    tiktok: @tiktok_regex,
    tiktok_vm: @tiktok_vm_regex,
    xtwitter: @xtwitter_replace
  }
  @all_fixes %{
    twitter: @twitter_fix,
    instagram: @instagram_fix,
    tiktok: @tiktok_fix,
    tiktok_vm: @tiktok_vm_fix,
    xtwitter: @xtwitter_fix
  }

  def maybe_fix(text) when is_binary(text) do
    case Enum.find(@all_regex, fn {_site, regex} -> String.match?(text, regex) end) do
      {site, _} -> fix_text(text, site)
      _ -> {:error, "No match"}
    end
  end

  def maybe_fix(_), do: {:error, "Not a string"}

  defp fix_text(text, site) do
    regex = @all_replaces[site]
    fix = @all_fixes[site]
    result = Regex.replace(regex, text, fix)

    {:ok, result, site}
  end

  def toggle_mp4(text) when is_binary(text) do
    text =
      case Regex.named_captures(@tiktok_vm_toggle_regex, text) do
        %{"url" => url, "video" => ""} ->
          new_url = "#{url}/video.mp4"
          Regex.replace(@tiktok_vm_toggle_regex, text, new_url)

        %{"url" => url} ->
          Regex.replace(@tiktok_vm_toggle_regex, text, url)
      end

    {:ok, text}
  end

  def toggle_mp4(_), do: {:error, "Not a string"}
end
