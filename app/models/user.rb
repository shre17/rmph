class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         # , authentication_keys: [:login]

  has_one :wallet, dependent: :destroy

  attr_writer :login

  def login
     @login || self.mobile_number || self.email
  end      
end
