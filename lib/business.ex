defmodule LittleJohn.Business do
  alias LittleJohn.Source.Data

  def user_exists?(token), do: Data.user_exists?(token)

  def all_users(), do: Data.all_users()

  def get_prices_by_ticker(ticker) do
    case Data.prices_by_ticker(ticker) do
      nil -> :not_found
      t -> {:ok, t.prices}
    end
  end

  def get_portfolio(token) do
    Data.portfolio(token)
  end
end
