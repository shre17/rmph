class Wallet < ApplicationRecord
  belongs_to :user, optional: true

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
end
