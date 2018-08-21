class WalletTransactionsController < ApplicationController
  layout 'admin'

  def new
    @transaction = WalletTransaction.new
    @transactions = WalletTransaction.where(user_id: current_user.id)
  end

  def  create
    @transaction = WalletTransaction.new(wallet_transaction_params)

    # Check if valid sponser
    @mob = WalletTransaction.check_user(@transaction) 
    if @mob == true
      respond_to do |format|
        if @transaction.save
          # Check the transfer_to user
          transfer_to = WalletTransaction.check_transfer_to(@transaction) 

          # Update Transaction histroy of sender
          @transaction.update_attributes(transfer_to: transfer_to.user_name, debit: @transaction.amount.to_i, credit: 0, open_balance: current_user.wallet.amount, close_balance: 0, remark: "Sent #{@transaction.amount} to #{transfer_to.user_name}", status: 1)

          # Update Transaction histroy of recevier
          WalletTransaction.transaction_histroy(current_user, @transaction)

          # Add tranfered money
          add_money = WalletTransaction.add_money(current_user, @transaction)

          # Dedcut tranfered money
          dedcut_money = WalletTransaction.deduct_money(current_user, @transaction)

          format.html { redirect_to new_wallet_transaction_path, notice: "Successfully transfer to #{transfer_to.user_name}." }
        else
          format.html { render 'new' }
        end
      end
    else
      redirect_to new_wallet_transaction_path, notice: "Not a valid sponser."
    end
  end

  def upgrade_level
    @transaction = WalletTransaction.new
    @transactions = WalletTransaction.where(user_id: current_user.id)
  end

  def create_level_transactions
    @transaction = WalletTransaction.new(wallet_transaction_params)
    respond_to do |format|
      if @transaction.save
        # Dedcut tranfered money
        WalletTransaction.deduct_money(current_user, @transaction)

        level = @transaction.level.split(" ")[2]
        amount = @transaction.amount.split(" ")[2]

        @transaction.update_attributes(level: level, amount: amount, transfer_to: level, debit: amount, credit: 0, open_balance: current_user.wallet.amount, close_balance: 0, remark: "Level #{level} Remain", status: 1)

        format.html { redirect_to levels_new_path, notice: "Successfully upgraded to." }
      else
        format.html { render 'upgrade_level' }
      end
    end
  end

  private

  def wallet_transaction_params
    params.require(:wallet_transaction).permit(:mobile_no, :amount, :transfer_by, :transfer_to, :user_id, :wallet_id, :level)
  end

end
