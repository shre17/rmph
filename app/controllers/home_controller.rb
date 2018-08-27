class HomeController < ApplicationController
  layout 'admin', only: [:direct_team, :profit_details]
  before_action :authenticate_user!, only: [:direct_team]

  def index
  end

  def direct_team
    @direct_team = current_user
    @sponser = User.where(sponser_id: current_user.mobile_number) 
    # @transaction_amount = WalletTransaction.find_by(mobile_no: @sponser.mobile_number,transfer_by: current_user.user_name, transfer_to: @sponser.user_name)
    # @level = WalletTransaction.where('level = ? ', "1")
  end

  def profit_details
    @child_users = User.where(sponser_id: current_user.mobile_number)
    @total_users = @child_users.count
    # @direct_income = WalletTransaction.where(transfer_to: current_user.user_name).map{|a| a.amount}
    # @sum = 0
    # @direct_income.each do |i|
    #   @sum += i.to_i
    # end
  end
end
