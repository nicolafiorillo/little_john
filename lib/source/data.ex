defmodule LittleJohn.Source.Data do
  @moduledoc """
  Keep data source session.
  Data are compleately generated each server session.
  """
  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Init
  def init(_opts) do
    # generate always the same values
    :rand.seed(:exsss, {100, 101, 102})

    history = generate_history()
    users = generate_users()
    {:ok, %{history: history, users: users}}
  end

  @tickers [
    "AAPL",
    "MSFT",
    "GOOG",
    "AMZN",
    "FB",
    "TSLA",
    "NVDA",
    "JPM",
    "BABA",
    "JNJ",
    "WMT",
    "PG",
    "PYPL",
    "DIS",
    "ADBE",
    "PFE",
    "V",
    "MA",
    "CRM",
    "NFLX"
  ]

  # Api
  def ticker_exists?(value), do: GenServer.call(__MODULE__, {:ticker_exists, value})

  def prices_by_ticker(ticker), do: GenServer.call(__MODULE__, {:prices_by_ticker, ticker})

  def user_exists?(token), do: GenServer.call(__MODULE__, {:user_exists, token})

  def portfolio(token), do: GenServer.call(__MODULE__, {:portfolio, token})

  def all_users(), do: GenServer.call(__MODULE__, :all_users)

  def state(), do: GenServer.call(__MODULE__, :state)

  # Callbacks
  def handle_call({:portfolio, token}, _from, %{history: history, users: users} = state) do
    {:reply, get_porfolio_for_user(token, users, history), state}
  end

  def handle_call({:prices_by_ticker, ticker}, _from, %{history: history} = state) do
    {:reply, Enum.find(history, fn t -> t.ticker == ticker end), state}
  end

  def handle_call({:ticker_exists, value}, _from, state) do
    {:reply, value in @tickers, state}
  end

  def handle_call(:all_users, _from, %{users: users} = state) do
    {:reply, Enum.map(users, & &1.token), state}
  end

  def handle_call({:user_exists, token}, _from, %{users: users} = state) do
    user = Enum.find(users, fn u -> u.token == token end)
    {:reply, not is_nil(user), state}
  end

  def handle_call(:state, _from, state), do: {:reply, state, state}

  # Helpers

  defp get_porfolio_for_user(token, users, history) do
    with user when not is_nil(user) <- Enum.find(users, fn u -> u.token == token end) do
      user.tickers
      |> Enum.map(fn t ->
        %{symbol: t, price: get_last_price(t, history)}
      end)
    else
      _ -> []
    end
  end

  defp get_last_price(ticker, history) do
    case Enum.find(history, fn h -> h.ticker == ticker end) do
      nil -> "n.a."
      t -> Enum.find(t.prices, fn p -> p.date == Date.utc_today() end).price
    end
  end

  defp generate_history() do
    @tickers
    |> Enum.map(fn ticker ->
      %{
        ticker: ticker,
        prices: generate_prices()
      }
    end)
  end

  @history_days 90
  @max_ticker_value 999_000
  @max_number_of_users 10

  defp generate_prices() do
    for d <- 0..(@history_days - 1) do
      day = Date.utc_today() |> Date.add(-d)

      %{
        date: day,
        price: Enum.random(0..@max_ticker_value) / 1_000
      }
    end
  end

  defp generate_users() do
    number_of_users = Enum.random(1..@max_number_of_users)

    for _u <- 1..number_of_users do
      %{
        token: random_token(),
        tickers: @tickers |> Enum.take_random(Enum.random(3..@max_number_of_users))
      }
    end
  end

  def random_token() do
    "01234567890qwertyuiopasdfghjklzxcvbnmwQWERTYUIOPASDFGHJKLZXCVBNM"
    |> String.codepoints()
    |> Enum.take_random(16)
    |> Enum.join()
  end
end
