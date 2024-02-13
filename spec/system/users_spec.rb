require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end
  let(:user) { FactoryBot.create(:user) }

  scenario "user signs up" do
    user = FactoryBot.build(:user)
    visit home_path
    click_link "Sign up new user"
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_button "Create my account"
    expect(page).to have_content("Please check your email for the activation link.")
  end

  scenario "user edit with friendly forwarding" do
    # ログインしていない状態で編集ページにアクセス
    get edit_user_path(user)

    # ログインを求められるのでログイン操作を行う
    login(user)

    # 最初にアクセスしたページ(編集画面)にリダイレクトされる
    pending "session[:forwarding_url]を取得できない"
    expect(page.current_path).to  eq "/users/#{user.id}/edit"
  end
end
