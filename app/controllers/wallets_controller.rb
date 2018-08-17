class WalletsController < ApplicationController
  layout 'admin'

  def new
    @wallet = Wallet.new
  end

  def  create
    @wallet = Wallet.new(wallet_params)
    @mob = Wallet.check_user(@wallet)
    if @mob == true
      respond_to do |format|
        if @wallet.save
          format.html { redirect_to new_wallet_path, notice: "successfully transfer." }
        else
          format.html { render 'new' }
        end
      end
    else
      redirect_to new_wallet_path, notice: "User not found."
    end
  end

  def show
    @wallet = Wallet.find(params[:id])
  end

  private

  def wallet_params
    params.require(:wallet).permit(:mobile_no, :amount, :transfer_by, :transfer_to, :user_id)
  end
end
