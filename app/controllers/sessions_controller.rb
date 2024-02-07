class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])

      # reset the session
      reset_session

      # login the user
      login @user

      # flash メッセージ
      flash[:success] = "ログインしました"
      # redirect to user_path
      redirect_to @user
    else
      # flash メッセージ
      flash.now[:danger] = "無効なユーザーIDまたはパスワードです。"
      # render new template
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    flash[:danger] = "ログアウトしました"
    redirect_to users_path 
  end
end
