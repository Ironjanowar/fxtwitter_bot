defmodule FxtwitterBot.FixerTest do
  use ExUnit.Case

  alias FxtwitterBot.Fixer

  describe "maybe_fix/1" do
    test "works" do
      assert {:ok, result} = Fixer.maybe_fix("https://twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = Fixer.maybe_fix("https://www.twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = Fixer.maybe_fix("http://twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} = Fixer.maybe_fix("http://www.twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:error, "No match"} = Fixer.maybe_fix("https://fxtwitter.com/user")

      assert {:error, "No match"} = Fixer.maybe_fix("twitter.com/user")

      assert {:ok, result} = Fixer.maybe_fix("http://mobile.twitter.com/user")
      assert result == "https://fxtwitter.com/user"

      assert {:ok, result} =
               Fixer.maybe_fix(
                 "https://twitter.com/archillect/status/1581623858918207488?s=20&t=0u3LTLBA9MRq7FA-_Ucxow"
               )

      assert result ==
               "https://fxtwitter.com/archillect/status/1581623858918207488?s=20&t=0u3LTLBA9MRq7FA-_Ucxow"

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

      assert {:ok, result} = Fixer.maybe_fix(text)
      assert result == expected
    end

    test "no replace" do
      assert {:error, "No match"} == Fixer.maybe_fix("no replace")
    end

    test "not a string" do
      assert {:error, "Not a string"} == Fixer.maybe_fix(1)
    end
  end
end
