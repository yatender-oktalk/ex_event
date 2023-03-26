defmodule ExEvent.Router.BankRouter do
  use Commanded.Commands.Router

  dispatch(ExEvent.Commands.OpenBankAccount,
    to: ExEvent.BankAccount,
    identity: :account_number
  )
end
