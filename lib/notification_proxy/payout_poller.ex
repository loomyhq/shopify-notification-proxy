defmodule NotificationProxy.PayoutPoller do
  @moduledoc """
  Logic to poll the Shopify api for payouts.
  """
  @type payout :: %{
          status: atom(),
          amount: float(),
          issued_at: DateTime.t()
        }

  @name :shopify_data

  @doc """
  Create the ETS table to store the payouts.
  """
  @spec create_ets_table :: :shopify_data
  def create_ets_table do
    :ets.new(@name, [:set, :public, :named_table])
  end

  @doc """
  Returns the list of payouts last seen.
  """
  @spec payouts :: {:ok, [payout()]}
  def payouts do
    case :ets.lookup(@name, "payouts") do
      [{"payouts", payouts}] ->
        {:ok, payouts}

      _ ->
        {:ok, []}
    end
  end

  @doc """
  Updates the payouts in the ETS table with the given list.
  """
  @spec payouts([payout()]) :: boolean()
  def payouts(payouts) do
    :ets.insert(@name, {"payouts", payouts})
  end

  @doc """
  Retrieves the latest payouts from Shopify and stores them in the database.
  Returns the list of new payouts previously unseen.
  """
  @spec update_payouts :: [payout()]
  def update_payouts do
    {:ok, latest_payouts} = NotificationProxy.Queries.payouts()
    {:ok, payouts} = payouts()

    # store the payouts
    payouts(latest_payouts)

    # do not return the initial list of payouts as new.
    if Enum.any?(payouts) do
      latest_payouts -- payouts
    else
      []
    end
  end

  @doc """
  Sends a notification on Slack when a new payout occurred.
  """
  @spec notify_new_payouts :: :ok
  def notify_new_payouts do
    total_payout =
      update_payouts()
      |> Enum.sum_by(& &1.amount)

    if total_payout > 0.0 do
      NotificationProxy.Slack.post("Shopify payout €#{total_payout}. Centjes rapen! 🥳💸")
    end
  end
end
