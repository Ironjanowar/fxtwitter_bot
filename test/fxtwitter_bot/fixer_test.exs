defmodule FxtwitterBot.FixerTest do
  use ExUnit.Case

  alias FxtwitterBot.Fixer

  describe "maybe_fix/1" do
    test "works" do
      assert {:ok, result} =
               Fixer.maybe_fix("https://twitter.com/rickroll/status/1093270903599726593")

      assert result == "https://fxtwitter.com/rickroll/status/1093270903599726593"

      assert {:ok, result} =
               Fixer.maybe_fix("https://www.twitter.com/rickroll/status/1093270903599726593")

      assert result == "https://fxtwitter.com/rickroll/status/1093270903599726593"

      assert {:ok, result} =
               Fixer.maybe_fix("http://twitter.com/rickroll/status/1093270903599726593")

      assert result == "https://fxtwitter.com/rickroll/status/1093270903599726593"

      assert {:ok, result} =
               Fixer.maybe_fix("http://www.twitter.com/rickroll/status/1093270903599726593")

      assert result == "https://fxtwitter.com/rickroll/status/1093270903599726593"

      assert {:ok, result} =
               Fixer.maybe_fix("http://mobile.twitter.com/rickroll/status/1093270903599726593")

      assert result == "https://fxtwitter.com/rickroll/status/1093270903599726593"

      assert {:ok, result} =
               Fixer.maybe_fix(
                 "https://twitter.com/archillect/status/1581623858918207488?s=20&t=0u3LTLBA9MRq7FA-_Ucxow"
               )

      assert result ==
               "https://fxtwitter.com/archillect/status/1581623858918207488?s=20&t=0u3LTLBA9MRq7FA-_Ucxow"

      text = """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      https://twitter.com/rickroll/status/1093270903599726593

      Suspendisse elementum https://twitter.com/rickroll/status/1093270903599726593 ante vitae

      dapibus convallis. Phasellus scelerisque mollis arcu suscipit https://twitter.com/rickroll/status/1093270903599726593
      """

      expected = """
      Lorem ipsum dolor sit amet, consectetur adipiscing elit.
      https://fxtwitter.com/rickroll/status/1093270903599726593

      Suspendisse elementum https://fxtwitter.com/rickroll/status/1093270903599726593 ante vitae

      dapibus convallis. Phasellus scelerisque mollis arcu suscipit https://fxtwitter.com/rickroll/status/1093270903599726593
      """

      assert {:ok, result} = Fixer.maybe_fix(text)
      assert result == expected
    end

    test "other services work" do
      assert {:ok, result} = Fixer.maybe_fix("https://instagram.com/user")
      assert result == "https://ddinstagram.com/user"

      assert {:ok, result} = Fixer.maybe_fix("https://vm.tiktok.com/user")
      assert result == "https://vm.dstn.to/user"
    end

    test "no match" do
      assert {:error, "No match"} = Fixer.maybe_fix("https://fxtwitter.com/user")

      assert {:error, "No match"} = Fixer.maybe_fix("twitter.com/user")

      assert {:error, "No match"} == Fixer.maybe_fix("no match")
    end

    test "not a string" do
      assert {:error, "Not a string"} == Fixer.maybe_fix(1)
    end
  end
end
