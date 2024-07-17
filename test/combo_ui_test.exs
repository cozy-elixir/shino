defmodule Shino.UITest do
  use ExUnit.Case
  doctest Shino.UI

  test "greets the world" do
    assert Shino.UI.hello() == :world
  end
end
