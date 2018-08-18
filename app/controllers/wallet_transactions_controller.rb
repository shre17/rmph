class WalletTransactionsController < ApplicationController
  layout 'admin'

  def new
    @transaction = WalletTransaction.new
    @transactions = WalletTransaction.all
  end

  def  create
    @transaction = WalletTransaction.new(wallet_transaction_params)
    @mob = WalletTransaction.check_user(@transaction)
    if @mob == true
      respond_to do |format|
        if @transaction.save
          transfer_to = WalletTransaction.check_transfer_to(@transaction)
          @transaction.update_attributes(transfer_to: transfer_to.user_name)
          format.html { redirect_to new_wallet_transaction_path, notice: "Successfully transfer to #{transfer_to.user_name}." }
        else
          format.html { render 'new' }
        end
      end
    else
      redirect_to new_wallet_transaction_path, notice: "Not a valid sponser."
    end
  end

  private

  def wallet_transaction_params
    params.require(:wallet_transaction).permit(:mobile_no, :amount, :transfer_by, :transfer_to, :user_id, :wallet_id)
  end

end
