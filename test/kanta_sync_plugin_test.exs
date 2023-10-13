defmodule Kanta.Sync.PluginTest do
  use ExUnit.Case
  doctest KantaSyncPlugin

  test "greets the world" do
    assert KantaSyncPlugin.hello() == :world
  end
end
