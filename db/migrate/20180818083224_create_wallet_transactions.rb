class CreateWalletTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :wallet_transactions do |t|
      t.string :mobile_no
      t.string :amount
      t.string :transfer_by
      t.string :transfer_to
      t.references :user, foreign_key: true
      t.references :wallet, foreign_key: true

      t.timestamps
    end
  end
end
