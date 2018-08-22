class WalletTransaction < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :wallet, optional: true

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

  def self.transaction_histroy(current_user, transaction)
    user = User.find_by(mobile_number: transaction.mobile_no)
    user_wallet = WalletTransaction.create(mobile_no: current_user.mobile_number, amount: transaction.amount, transfer_by: current_user.user_name, transfer_to: current_user.user_name, user_id: user.id, wallet_id: user.wallet.id, debit: 0, credit: transaction.amount, open_balance: user.wallet.amount, close_balance: 0, remark: "Recevied #{transaction.amount} from #{current_user.user_name}", status: 1)
    return user_wallet
  end

  def self.add_money(current_user, transaction)
    user = User.find_by(mobile_number: transaction.mobile_no)
    wallet = Wallet.find_by(user_id: user.id)
    total_amount = wallet.amount.to_i + transaction.amount.to_i
    wallet.update_attributes(amount: total_amount)
    return total_amount
  end


  def self.deduct_money(current_user, transaction)
    user = User.find_by(mobile_number: current_user.mobile_number)
    wallet = Wallet.find_by(user_id: user.id)
    if transaction.level.present?
      level_amount = transaction.amount.split(" ")[2]
      total_amount = wallet.amount.to_i - level_amount.to_i
    else
      total_amount = wallet.amount.to_i - transaction.amount.to_i
    end
    wallet.update_attributes(amount: total_amount)
    return total_amount
  end

end
