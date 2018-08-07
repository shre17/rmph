class ChangePasswordsController < ApplicationController
  layout 'admin'
  def edit
    @user = current_user
  end

  def change_password
    @user = current_user
    if @user.update_with_password(user_params)
      # Sign in the user by passing validation in case their password changed
      bypass_sign_in(@user)
      redirect_to root_path
    else
      render "edit"
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :current_password, :password_confirmation)
  end
end