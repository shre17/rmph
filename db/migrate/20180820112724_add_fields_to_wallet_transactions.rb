class AddFieldsToWalletTransactions < ActiveRecord::Migration[5.1]
  def change
    add_column :wallet_transactions, :debit, :string
    add_column :wallet_transactions, :credit, :string
    add_column :wallet_transactions, :open_balance, :string
    add_column :wallet_transactions, :close_balance, :string
    add_column :wallet_transactions, :remark, :string
    add_column :wallet_transactions, :status, :string
  end
end
