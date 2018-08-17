class CreateWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.string :mobile_no
      t.string :amount
      t.string :transfer_by
      t.string :tranfer_to
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
