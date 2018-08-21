class AddFieldToWalletTransaction < ActiveRecord::Migration[5.1]
  def change
    add_column :wallet_transactions, :level, :string
  end
end
