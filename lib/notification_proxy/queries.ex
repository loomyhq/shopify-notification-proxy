defmodule NotificationProxy.Queries do
  @moduledoc false

  require Logger

  @payouts_path :code.priv_dir(:notification_proxy)
                |> Path.join("graphql")
                |> Path.join("payouts.graphql")

  @external_resource @payouts_path

  @payouts_query File.read!(@payouts_path)

  @doc """
  Return a list of the last 10 payouts from Shopify
  """
  @spec payouts :: {:ok, [map()]} | {:error, :failed_to_get_payouts}
  def payouts do
    operation = @payouts_query

    case send_operation(operation) do
      {:ok, response} ->
        payouts =
          response
          |> get_in([:data, :shopifyPaymentsAccount, :payouts, :edges])
          |> Enum.map(&Map.get(&1, :node))
          |> Enum.map(fn payout ->
            {:ok, issued_at, 0} = DateTime.from_iso8601(payout.issuedAt)

            %{
              status: String.to_atom(String.downcase(payout.status)),
              amount: String.to_float(payout.net.amount),
              issued_at: issued_at
            }
          end)

        {:ok, payouts}

      {:error, _} ->
        {:error, :failed_to_get_payouts}
    end
  end

  defp send_operation(operation) do
    response =
      Shopify.GraphQL.send(operation,
        access_token: Application.get_env(:notification_proxy, :shopify_api_token),
        shop: Application.get_env(:notification_proxy, :shopify_shop),
        version: "2025-07"
      )

    case response do
      {:ok, %{status_code: 200, body: body}} ->
        body = Jason.encode!(body) |> Jason.decode!(keys: :atoms)
        {:ok, body}

      _ ->
        Logger.error("failed to send request")

        {:error, :failed}
    end
  end
end
