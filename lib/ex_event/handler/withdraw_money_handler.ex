defmodule ExEvent.Handler.WithdrawMoneyHandler do
  alias ExEvent.BankAccount
  alias ExEvent.Commands.WithdrawMoney

  @behaviour Commanded.Commands.Handler

  def handle(%BankAccount{} = aggregate, %WithdrawMoney{} = command) do
    %WithdrawMoney{account_number: account_number, amount: amount} = command
    BankAccount.withdraw_money(aggregate, account_number, amount)
  end
end
