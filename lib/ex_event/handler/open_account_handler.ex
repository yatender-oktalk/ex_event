defmodule ExEvent.Handler.OpenAccountHandler do
  alias ExEvent.BankAccount
  alias ExEvent.Commands.OpenBankAccount

  @behaviour Commanded.Commands.Handler

  def handle(%BankAccount{} = aggregate, %OpenBankAccount{} = command) do
    %OpenBankAccount{account_number: account_number, initial_balance: initial_balance} = command
    BankAccount.open_account(aggregate, account_number, initial_balance)
  end
end
