defmodule Benanachain.PageView do
  use Benanachain.Web, :view

  def render(conn, %{events: events}) do
    %{
      events: Enum.map(events, &event_json/1)
    }
  end

  defp event_json(event) do
    %{
      owner: event.owner,
      recipient: event.recipient,
      amount: event.amount
    }
  end
end
