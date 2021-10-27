defmodule Router do
  @moduledoc """
  Main API router.
  """
  use Plug.Router
  alias Plug.Conn.Status
  alias LittleJohn.Business

  require Logger

  plug(Plug.Logger)
  plug(:auth)
  plug(:match)
  plug(:dispatch)

  get "/tickers" do
    portfolio = Business.get_portfolio(conn.assigns[:key])
    send_resp(conn, Status.code(:ok), Jason.encode!(portfolio))
  end

  get "/tickers/:ticker/history" do
    case Business.get_prices_by_ticker(ticker) do
      {:ok, prices} ->
        send_resp(conn, Status.code(:ok), Jason.encode!(prices))

      :not_found ->
        send_resp(conn, Status.code(:not_found), "ticker not found")
    end
  end

  match _ do
    Logger.info("Unknown request (params: #{inspect(conn.params)})")
    send_resp(conn, Status.code(:not_found), "not found")
  end

  defp auth(conn, _opts) do
    with {key, _pass} <- Plug.BasicAuth.parse_basic_auth(conn),
         true <- LittleJohn.Business.user_exists?(key) do
      assign(conn, :key, key)
    else
      _ -> conn |> Plug.BasicAuth.request_basic_auth() |> halt()
    end
  end
end
