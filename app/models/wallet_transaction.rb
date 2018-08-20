class WalletTransaction < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :wallet, optional: true
  after_create :add_money_to_wallet

  def self.check_user(user)
    user_mob = User.all.map{ |a| a.mobile_number }
    user_mob.each do |mob|
      if mob == user.mobile_no
        return true
      end
    end
  end

  def self.check_transfer_to(user)
    user_mob = user.mobile_no
    user = User.find_by(mobile_number: user_mob)
    return user
  end

  def add_money_to_wallet
    user = User.find_by(mobile_number: self.mobile_no)
    wallet = Wallet.find_by(user_id: user.id)
    total_amount = wallet.amount.to_i + self.amount.to_i
    wallet.update_attributes(amount: total_amount)
  end
  
end