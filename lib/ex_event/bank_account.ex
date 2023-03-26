defmodule ExEvent.BankAccount do
  defstruct [:account_number, :balance, :state]

  alias Commanded.Aggregate.Multi
  alias ExEvent.BankAccount
  alias ExEvent.Commands.{BankAccountOpened, OpenBankAccount, WithdrawMoney, MoneyWithdrawn, AccountOverdrawn}
  alias __MODULE__

  def execute(%BankAccount{account_number: nil}, %OpenBankAccount{
        account_number: account_number,
        initial_balance: initial_balance
      })
      when initial_balance > 0 do
    %BankAccountOpened{account_number: account_number, initial_balance: initial_balance}
  end

  # Ensure initial balance is never zero or negative
  def execute(%BankAccount{}, %OpenBankAccount{initial_balance: initial_balance})
      when initial_balance <= 0 do
    {:error, :initial_balance_must_be_above_zero}
  end

  # Ensure account has not already been opened
  def execute(%BankAccount{}, %OpenBankAccount{}) do
    {:error, :account_already_opened}
  end

  def execute(%BankAccount{state: :active} = account, %WithdrawMoney{amount: amount}) when is_number(amount) do
    account
    |> Multi.new()
    |> Multi.execute(&withdraw_money(&1, amount))
    |> Multi.execute(&check_balance/1)
  end

  def withdraw_money(%BankAccount{account_number: account_number, balance: balance}, amount) do
    event = %MoneyWithdrawn{
      account_number: account_number,
      amount: amount,
      balance: balance - amount
    }

    {:ok, event}
  end

  def check_balance(%BankAccount{account_number: account_number, balance: balance}) when balance > 0 do
    event = %AccountOverdrawn{account_number: account_number, balance: balance}
    {:ok, event}
  end

  def check_balance(%BankAccount{}), do: :ok

  # State mutators
  # in apply which modifies the state first arg will be the state of the aggregate
  # the response of apply would be the updated state

  def apply(%BankAccount{} = account, %BankAccountOpened{} = event) do
    %BankAccountOpened{account_number: account_number, initial_balance: initial_balance} = event

    %BankAccount{account | account_number: account_number, balance: initial_balance}
  end

  ### Public APIs

  def open_bank_account(%BankAccount{account_number: nil}, account_number, initial_balance) when initial_balance > 0 do
    event = %BankAccountOpened{account_number: account_number, initial_balance: initial_balance}
    {:ok, event}
  end

  def open_account(%BankAccount{}, _account_number, initial_balance) when initial_balance <= 0 do
    {:error, :initial_balance_must_be_above_zero}
  end

  def open_account(%BankAccount{}, _account_number, _initial_balance) do
    {:error, :account_already_opened}
  end
end
