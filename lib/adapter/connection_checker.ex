defmodule Kanta.Sync.Adapter.ConnectionChecker do
  @moduledoc false

  import Kanta.Sync.Adapter

  def call do
    with {:ok, %Tesla.Env{status: 200, body: body}} <-
           get("/"),
         %{"status" => "OK"} <-
           body do
      true
    else
      _x ->
        false
    end
  end
end
