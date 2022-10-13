defmodule FxtwitterBotTest do
  use ExUnit.Case
  doctest FxtwitterBot

  describe "replace_urls/1" do
    test "works" do
      assert {:ok, result} = FxtwitterBot.replace_urls("https://twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("https://www.twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("http://twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("http://www.twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("https://fxtwitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("twitter.com/user")
      assert result == "twitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("http://mobile.twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      text = """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      https://twitter.com/user

      Suspendisse elementum https://twitter.com/user ante vitae

      dapibus convallis. Phasellus scelerisque mollis arcu suscipit https://twitter.com/user
      """

      expected = """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      https://fxtwitter.com/user

      Suspendisse elementum https://fxtwitter.com/user ante vitae

      dapibus convallis. Phasellus scelerisque mollis arcu suscipit https://fxtwitter.com/user
      """

      assert {:ok, result} = FxtwitterBot.replace_urls(text)
      assert result == expected
    end

    test "no replace" do
      assert {:ok, "no replace"} == FxtwitterBot.replace_urls("no replace")
    end

    test "not a string" do
      assert {:error, "Not a string"} == FxtwitterBot.replace_urls(1)
    end
  end

  describe "maybe_fix/1" do
    test "works" do
      assert {:ok, result} = FxtwitterBot.maybe_fix("https://twitter.com/user")
      assert result == "https://fxtwitter.com/user"
    end

    test "no match" do
      assert {:error, "No match"} == FxtwitterBot.maybe_fix("no match")
    end

    test "not a string" do
      assert {:error, "Not a string"} == FxtwitterBot.maybe_fix(1)
    end
  end
end
