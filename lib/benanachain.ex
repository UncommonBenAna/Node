defmodule Benanachain do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec
    {:ok, agent} = Agent.start_link fn -> %{nodes: [], events: [], blocks: []} end

    # Define workers and child supervisors to be supervised
    children = [
      # supervisor(Benanachain.Repo, []),
      
      supervisor(Benanachain.Endpoint, []),
      
      worker(Benanachain.Client, [agent])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Benanachain.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Benanachain.Endpoint.config_change(changed, removed)
    :ok
  end
end
