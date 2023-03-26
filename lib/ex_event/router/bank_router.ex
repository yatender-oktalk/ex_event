defmodule ExEvent.Router.BankRouter do
  use Commanded.Commands.Router

  dispatch(ExEvent.Commands.OpenBankAccount,
    to: ExEvent.Handler.OpenAccountHandler,
    aggregate: ExEvent.BankAccount,
    identity: :account_number
  )

  dispatch(ExEvent.Commands.WithdrawMoney,
  to: ExEvent.Handler.WithdrawMoneyHandler,
  aggregate: BankAccount,
  identity: :account_number
  )

end
