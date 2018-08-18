class WalletTransaction < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :wallet, optional: true

  def self.check_user(user)
    user_mob = User.all.map{ |a| a.mobile_number }
    user_mob.each do |mob|
      if mob == user.mobile_no
        return true
      else
        return false
      end
    end
  end

  def self.check_transfer_to(user)
    user_mob = user.mobile_no
    user = User.find_by(mobile_number: user_mob)
    return user
  end
  
end
