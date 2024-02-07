require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let(:user) {FactoryBot.create(:user)}
  describe "GET /new" do
    it "returns http success" do
      get "/sessions/new"
      expect(response).to have_http_status(:success)
    end
  end

  context "無効なユーザー情報の場合" do
    it "フラッシュメッセージが表示されること" do
      get "/login"
      invalid_params = {session: {email: "", password: "" }}
      post "/login", params: invalid_params
      expect(flash[:danger]).to_not be nil
    end

    it "loginページがレンダリングされること" do
      get "/login"
      invalid_params = {session: {email: "", password: "" }}
      post "/login", params: invalid_params
      expect(response).to render_template("sessions/new")
      # rails-controler-testing is needed
    end
  end

  context "有効なユーザーの場合" do
    it "フラッシュメッセージが表示されること" do
      get "/login"
      valid_params = {session: {email: user.email, password: user.password}}
      post "/login", params: valid_params
      expect(flash[:success]).to include("ログインしました")
    end
  
    it "ユーザーページにリダイレクトされること" do
      get "/login"
      valid_params = {session: {email: user.email, password: user.password}}
      post "/login", params: valid_params
      expect(response).to redirect_to(user_path(user))
    end

    it "有効なセッションが存在すること" do
      get "/login"
      valid_params = {session: {email: user.email, password: user.password}}
      post "/login", params: valid_params
      expect(session[:user_id]).to eq(user.id)
    end

  end

  describe "DELETE /destroy" do
    it "ログアウトできること" do
      get "/login"
      valid_params = {session: {email: user.email, password: user.password}}
      post "/login", params: valid_params
      delete "/logout"
      expect(response).to redirect_to(users_path)
      expect(flash[:danger]).to include("ログアウトしました")
    end

  end


end
