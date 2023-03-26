defmodule ExEvent.Router do
  use Commanded.Application,
    otp_app: :ex_event,
    event_store: [
      adapter: Commanded.EventStore.Adapters.EventStore,
      event_store: ExEvent.EventStore
    ],
    pubsub: :local,
    registry: :local

  router(ExEvent.Router.BankRouter)
end
