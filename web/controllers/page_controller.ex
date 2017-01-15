defmodule Benanachain.PageController do
  use Benanachain.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def get_events(conn, _params) do
    render conn, "event.json", events: Benanachain.Client.get_events
  end

  def new_block(conn, _params) do

  end

  def new_event(conn, %{"owner" => owner, "recipient" => recipient, "amount" => amount}) do
    alias Benanachain.Event
    cs = Event.changeset(%Event{}, %{owner: owner, recipient: recipient, amount: amount})

    case cs.valid? do
      true ->
        Benanachain.Repo.insert cs
        conn |> put_status(:created) |> send_resp(301, "")
      false ->
        conn |> put_status(500) |> send_resp(500, "")
    end
  end

  def new_event(conn, _) do
    text conn, "invalid params"
  end

  def ping(conn, _params) do
    text conn, "pong"
  end
end
