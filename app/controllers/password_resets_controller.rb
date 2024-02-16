class PasswordResetsController < ApplicationController

  before_action :get_user, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by(email: params[:password_resets][:email])
    if @user 
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Password reset email has been sent to #{@user.email}"
      redirect_to home_path
    else
      flash.now[:danger] = "Email not found"
      render :new, status: :unprocessable_entity
    end
  end


  def edit
    # emailのリンクがクリックされた時に呼び出しされる
    user = User.find_by(email: params[:email])
    if user && user.activated? && user.authenticated?(:reset, params[:id])
      render :edit
    else
      flash[:danger] = "ユーザーが有効化されていません. サインアップしてください"
      redirect_to new_user_path
    end
  end


  def update
    @user = User.find_by(email: params[:email])
    if @user.update(user_params)
      login @user
      flash[:success] = "パスワードを変更しました"
      redirect_to @user
    else
      flash.now[:danger] = "パスワードを更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def get_user
    @user = User.find_by(email: params[:email])
  end

end
