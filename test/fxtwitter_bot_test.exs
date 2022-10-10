defmodule FxtwitterBotTest do
  use ExUnit.Case
  doctest FxtwitterBot

  describe "replace_urls/1" do
    test "works" do
      assert {:ok, result} = FxtwitterBot.replace_urls("https://twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("https://www.twitter.com/user")
      assert result == "https://www.fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("twitter.com/user")
      assert result == "fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("http://twitter.com/user")
      assert result == "http://fxtwitter.com/user"

      assert {:ok, result} = FxtwitterBot.replace_urls("http://www.twitter.com/user")
      assert result == "http://www.fxtwitter.com/user"

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
  end
end
