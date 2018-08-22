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
    # Check if user has enough amount in wallet for transaction
    if @transaction.amount <= current_user.wallet.amount 
      if @mob == true
        respond_to do |format|
          if @transaction.save
            # Check the transfer_to user
            transfer_to = WalletTransaction.check_transfer_to(@transaction) 

            # Update Transaction histroy of sender
            @transaction.update_attributes(transfer_to: transfer_to.user_name, debit: @transaction.amount.to_i, credit: 0, open_balance: current_user.wallet.amount, close_balance: 0, remark: "Sent #{@transaction.amount} to #{transfer_to.user_name}", status: 1)

            # Update Transaction histroy of recevier
            @user_transaction = WalletTransaction.transaction_histroy(current_user, @transaction)

            # Add tranfered money
            add_money = WalletTransaction.add_money(current_user, @transaction)

            # Dedcut tranfered money
            dedcut_money = WalletTransaction.deduct_money(current_user, @transaction)

            # update close balance of sender
            @transaction.update(close_balance: dedcut_money)

            #update close balance of recevier
            @user_transaction.update(close_balance: add_money)

            format.html { redirect_to new_wallet_transaction_path, notice: "Successfully transfer to #{transfer_to.user_name}." }
          else
            format.html { render 'new' }
          end
        end
      else
        redirect_to new_wallet_transaction_path, alert: "Not a valid sponser."
      end
    else
      redirect_to new_wallet_transaction_path, alert: "You don't have enough balance."
    end
  end

  def upgrade_level
    @transaction = WalletTransaction.new
    @transactions = WalletTransaction.where(user_id: current_user.id)
  end

  def create_level_transactions
    @transaction = WalletTransaction.new(wallet_transaction_params)

    level = @transaction.level.split(" ")[2]
    amount = @transaction.amount.split(" ")[2]

    if amount <= current_user.wallet.amount
      respond_to do |format|
        if @transaction.save
          # Dedcut tranfered money
          dedcut_money = WalletTransaction.deduct_money(current_user, @transaction)

          @transaction.update_attributes(level: level, amount: amount, transfer_to: level, debit: amount, credit: 0, open_balance: current_user.wallet.amount, close_balance: dedcut_money, remark: "Level #{level} Remain", status: 1)

          format.html { redirect_to levels_new_path, notice: "Successfully upgraded to." }
        else
          format.html { render 'upgrade_level' }
        end
      end
    else
      redirect_to levels_new_path, alert: "You don't have enough balance."
    end
  end

  private

  def wallet_transaction_params
    params.require(:wallet_transaction).permit(:mobile_no, :amount, :transfer_by, :transfer_to, :user_id, :wallet_id, :level)
  end

end
