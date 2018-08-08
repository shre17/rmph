class AdminController < ApplicationController
  before_action :authenticate_user!
  layout 'admin'

  def referral
    @user = current_user
  end 

  def direct_team
  end

  def wallet_transfer
  end

  def upgrade
  end
end
