defmodule Puppies.BlacklistsProcessorText do
  use ExUnit.Case
  # doctest BlacklistsProcessor

  alias Puppies.BlacklistsProcessor

  describe "Scan content duplicate content" do
    test "returns true for duplicate content" do
      res = BlacklistsProcessor.duplicate_content("this is a test", "this is a test")
      assert(res == true)
    end

    test "returns false for no bad word found" do
      res = BlacklistsProcessor.duplicate_content("this is a test", "this is a test!")
      assert(res == false)
    end
  end
end
