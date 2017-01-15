defmodule Benanachain.Client do
  use GenServer
  alias Benanachain.Node

  def get_nodes do
    GenServer.call(__MODULE__, :get_nodes)
  end

  def update_nodes do
    GenServer.cast(__MODULE__, :update_nodes)
  end

  def get_events do
    GenServer.call(__MODULE__, :get_events)
  end

  def update_events do
    GenServer.cast(__MODULE__, :update_events)
  end

  def add_event(event) do
    GenServer.cast(__MODULE__, {:add_event, event})
  end

  def start_link(agent) do
    GenServer.start_link(__MODULE__, {:ok, agent}, [name: __MODULE__])
  end

  def init({:ok, agent}) do
    get_node_list |> decode_nodes |> store_nodes(agent)

    {:ok, %{agent: agent}}
  end

  def handle_call(:get_nodes, _from, state = %{agent: agent}) do
    {:reply, get_stored_nodes(agent), state}
  end

  def handle_cast(:update_nodes, state = %{agent: agent}) do
    get_node_list |> decode_nodes |> store_nodes(agent)
    {:noreply, state}
  end

  def handle_call(:get_events, _from, state = %{agent: agent}) do
    {:reply, get_stored_events(agent), state}
  end

  def handle_cast(:update_events, state = %{agent: agent}) do
    choose_random_node |> get_event_list |> decode_events |> store_events(agent)

    {:noreply, state}
  end

  def handle_cast({:add_event, event}, state = %{agent: agent}) do
    agent |> add_event(event)

    {:noreply, state}
  end

  defp register do
    {:ok, %HTTPoison.Response{status_code: 301}} = HTTPoison.post("http://localhost:4000/api/register", "")
  end

  defp get_node_list do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("http://localhost:4000/api/nodes")
    body
  end

  defp decode_nodes(body) do
    {:ok, %{"nodes" => nodes}} = Poison.decode(body)

    nodes
  end

  defp store_nodes(nodes, agent) do
    Agent.update agent, fn data -> %{data | nodes: nodes} end
  end

  defp get_stored_nodes(agent) do
    Agent.get(agent, fn %{nodes: nodes} -> nodes end)
  end

  defp choose_random_node do
    Benanachain.Client.get_nodes |> Enum.random
  end

  defp get_event_list(node) do
    {:ok, %HTTPoison.Response{body: body, status_code: 200}} = HTTPoison.get ("http://#{node["ip"]}:4000/api/events")
    body
  end

  defp decode_events(body) do
    {:ok, %{"events" => events}} = Poison.decode(body)

    events
  end

  defp store_events(events, agent) do
    Agent.update agent, fn data -> %{data | events: events} end
  end

  defp get_stored_events(agent) do
    Agent.get(agent, fn %{events: events} -> events end)
  end

  defp add_event(agent, event) do
    Agent.update(agent, fn data = %{events: events} -> %{data | events: [event|events]} end)
  end
end
