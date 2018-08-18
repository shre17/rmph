class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # , authentication_keys: [:login]

  has_many :wallet_transactions
  has_one :wallet, through: :wallet_transactions
  after_create :create_wallet

  def create_wallet
    Wallet.create!
  end 

  attr_writer :login

  def login
     @login || self.mobile_number || self.email
  end      
end
