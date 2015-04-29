defmodule Neox.Client do
  use HTTPotion.Base

  def process_url(_) do
    "http://localhost:7474/db/data/transaction/commit"
  end

  def process_request_headers(_) do
    [{"Authorization", "Basic bmVvNGo6cmVlcGE1Njc="},
     {"Accept", "application/json; charset=UTF-8"},
     {"Content-Type", "application/json"}]
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
  end

  def process_request_body(body) do
    body
    |> Poison.Encoder.encode []
  end
end
