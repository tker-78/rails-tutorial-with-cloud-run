require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "ユーザー登録ページにアクセスできること" do
      get new_user_path
      expect(response).to have_http_status(200)
    end
  end

  describe "POST /users" do
    let(:user) { FactoryBot.build(:user)}
    it "ユーザーの新規作成の成功時には、リダイレクトされること" do
      get new_user_path
      post users_path, params: { user: { name: user.name, email: user.email, password: "password", password_confirmation: "password"} } 
      expect(response).to have_http_status(302)
    end
  end
end
