class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      login user
      flash[:success] = "your account has been activated."
      redirect_to user
    else
      flash[:danger] = "account activation failed."
      redirect_to home_path
    end
  end
end
