class HomeController < ApplicationController
  layout 'admin', only: [:direct_team]
  before_action :authenticate_user!, only: [:direct_team]

  def index
  end

  def direct_team
    @direct_team = current_user
    if @direct_team.sponser_id.present?
      @sponser = User.find_by(mobile_number: @direct_team.sponser_id) 
      @transaction_amount = WalletTransaction.find_by(mobile_no: @sponser.mobile_number,transfer_by: current_user.user_name, transfer_to: @sponser.user_name)
      @level = WalletTransaction.where('level = ? ', "1")
    end
  end
end
