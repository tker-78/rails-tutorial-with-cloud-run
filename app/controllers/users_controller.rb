class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page], per_page: 3)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      reset_session
      login @user
      flash[:success] = "User created!"
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user == current_user && @user.update(user_params)
      flash[:success] = "user updated!"
      redirect_to @user
    else
      flash.now[:danger] = "Something went wrong!"
      render 'edit', status: :unprocessable_entity
    end

  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "User deleted!"
    redirect_to users_path
  end


  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "ログインしてください"
      redirect_to login_path
    end
  end

  # paramsで受け取ったユーザーが、ログインしているユーザーかどうかを判定する
  def correct_user
    @user = User.find(params[:id])
    if @user != current_user
      flash[:danger] = "権限がありません"
      redirect_to edit_user_path(current_user) 
    end
  end

  def admin_user
    if !current_user.admin?
      flash[:danger] = "権限がありません"
      redirect_to(users_path, status: :see_other)
    end
  end
end
