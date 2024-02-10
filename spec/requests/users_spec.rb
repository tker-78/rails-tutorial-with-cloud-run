require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users" do
    it "インデックスページが表示されること" do
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /users/:id/edit" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:other_user) }
    context "ログインしている場合" do
      before do
        login user
      end
      it "編集ページが表示されること" do
        get edit_user_path(user)
        expect(response).to render_template(:edit)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get edit_user_path(user)
        expect(response).to redirect_to(login_path)
      end
      it "フラッシュメッセージが表示されること" do
        get edit_user_path(user)
        expect(flash[:danger]).to eq("ログインしてください")
      end
    end

    context "間違ったユーザーでログインしている場合" do
      before do
        login other_user
      end
      it "フラッシュメッセージが表示されること" do
        get edit_user_path(user)
        expect(flash[:danger]).to eq("権限がありません")
      end
    end
  end

  describe "POST /users" do
    let(:user) { FactoryBot.build(:user)}
    context "有効なユーザー情報の場合" do
      it "ユーザーの新規作成の成功時には、リダイレクトされること" do
        get new_user_path
        post users_path, params: { user: { name: user.name, email: user.email, password: "password", password_confirmation: "password"} } 
        expect(response).to have_http_status(302)
      end
      it "ユーザー作成時にフラッシュメッセージが表示されること" do
        get new_user_path
        post users_path, params: { user: { name: user.name, email: user.email, password: "password", password_confirmation: "password"} }
        expect(flash[:success]).to eq("User created!")
      end

      it "ユーザー登録時にユーザー情報ページにリダイレクトされること" do
        get new_user_path
        post users_path, params: { user: { name: user.name, email: user.email, password: "password", password_confirmation: "password"} }
        @user = User.find_by(email: user.email)
        expect(response).to redirect_to(@user)
      end
    end
    
    context "無効なユーザー情報の場合" do
      it "無効なユーザー情報の場合、エラーメッセージが表示されること" do
        get new_user_path
        post users_path, params: {user: { name: "", email: "", password: "", password_confirmation: "" }}
        expect(response.body).to include("Email is invalid", "Name can&#39;t be blank", "Password can&#39;t be blank", "Name can&#39;t be blank")
      end
    end

  end
end
