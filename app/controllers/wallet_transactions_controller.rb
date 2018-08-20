class WalletTransactionsController < ApplicationController
  layout 'admin'

  def new
    @transaction = WalletTransaction.new
    @transactions = WalletTransaction.where(user_id: current_user.id)
  end

  def  create
    @transaction = WalletTransaction.new(wallet_transaction_params)
    @mob = WalletTransaction.check_user(@transaction) # Check if valid sponser
    if @mob == true
      respond_to do |format|
        if @transaction.save
          transfer_to = WalletTransaction.check_transfer_to(@transaction) # Check the transfer_to user
          @transaction.update_attributes(transfer_to: transfer_to.user_name)

          WalletTransaction.create(mobile_no: current_user.mobile_number, amount: @transaction.amount, transfer_by: current_user.user_name, transfer_to: transfer_to.user_name, user_id: transfer_to.id, wallet_id: transfer_to.wallet.id, debit: 0, credit: @transaction.amount, open_balance: 0, close_balance: transfer_to.wallet.amount, remark: "Recevied #{@transaction.amount} from #{current_user.user_name}", status: 1)

          # deduct money from wallet
          user = User.find_by(mobile_number: current_user.mobile_number)
          wallet = Wallet.find_by(user_id: user.id)
          total_amount = wallet.amount.to_i - @transaction.amount.to_i
          wallet.update_attributes(amount: total_amount)
          # end

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
