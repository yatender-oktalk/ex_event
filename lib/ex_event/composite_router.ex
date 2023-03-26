defmodule ExEvent.CompositeRouter do
  @moduledoc """
    ExEvent.CompositeRouter.dispatch(%ExEvent.Commands.OpenBankAccount{account_number: "ACC1445", initial_balance: 1_000})
  """
  use Commanded.Application,
    otp_app: :ex_event,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: ExEvent.EventStore
    ],
    pubsub: :local,
    registry: :local,
    snapshotting: %{
      ExEvent.BankAccount => [
        snapshot_every: 10,
        snapshot_version: 1
      ]
    }

  router(ExEvent.Router.BankRouter)
end
