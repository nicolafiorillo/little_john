defmodule LittleJohn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp port(), do: Application.get_env(:little_john, :port, 8080)

  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: Router, options: [port: port()]},
      LittleJohn.Source.Data
      # Starts a worker by calling: LittleJohn.Worker.start_link(arg)
      # {LittleJohn.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: LittleJohn.Supervisor]
    sup = Supervisor.start_link(children, opts)

    IO.puts("Listening to 127.0.0.1:#{port()}")
    IO.puts("Registered users (token): #{inspect(LittleJohn.Business.all_users())}")

    sup
  end
end
