defmodule TestQuantum.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec
    
    children = [
      # Starts a worker by calling: TestQuantum.Worker.start_link(arg)
      # {TestQuantum.Worker, arg}
      worker(TestQuantum.Scheduler, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TestQuantum.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
