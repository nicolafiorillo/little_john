defmodule RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Router.init([])

  test "returns tickers for user" do
    conn =
      conn(:get, "/tickers")
      |> put_req_header("authorization", "Basic #{get_a_user()}")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    data = Jason.decode!(conn.resp_body)
    assert length(data) > 0
  end

  test "returns prices for ticker" do
    conn =
      conn(:get, "/tickers/AAPL/history")
      |> put_req_header("authorization", "Basic #{get_a_user()}")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 200

    data = Jason.decode!(conn.resp_body)
    assert length(data) > 0
  end

  test "Unknown request" do
    conn =
      conn(:get, "/unknown")
      |> put_req_header("authorization", "Basic #{get_a_user()}")
      |> Router.call(@opts)

    assert conn.state == :sent
    assert conn.status == 404
  end

  test "invalid auth request" do
    conn =
      conn(:get, "/unknown")
      |> put_req_header(
        "authorization",
        "Basic MjU1MzQ4NzAtMjlmNi00ODAzLTkzYWMtYjExNDk2NGVmMmEyOjI1NTM0ODcwLTI5ZjYtNDgwMy05M2FjLWIxMTQ5NjRlZjJhMg=="
      )
      |> Router.call(@opts)

    assert conn.state == :set
    assert conn.status == 401
  end

  defp get_a_user(), do: LittleJohn.Source.Data.all_users() |> List.first()
end
