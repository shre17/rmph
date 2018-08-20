class Wallet < ApplicationRecord
  has_many :wallet_transactions, dependent: :destroy
  has_many :users, dependent: :destroy
end
