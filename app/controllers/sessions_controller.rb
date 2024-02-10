class SessionsController < ApplicationController
  def new
  end

  def create
    # userはviewからの呼び出しが不要なので、インスタンス変数にする必要なし
    user = User.find_by(email: params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      # 直前にアクセスしようとしたurlがあれば取り出す
      forwarding_url = session[:forwarding_url]

      # reset the session
      reset_session

      # login the user
      login user

      # checkboxがonの場合、remember digestを生成する
      if params[:session][:remember_me] == '1' 
        remember user
      end

      # flash メッセージ
      flash[:success] = "ログインしました"
      # redirect to user_path
      redirect_to forwarding_url  || user
    else
      # flash メッセージ
      flash.now[:danger] = "無効なユーザーIDまたはパスワードです。"
      # render new template
      render 'new', status: :unprocessable_entity
    end
  end

  def destroy
    current_user.forget # remember digestを削除する
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
    @current_user = nil
    reset_session
    
    flash[:danger] = "ログアウトしました"
    redirect_to users_path 
  end
end
