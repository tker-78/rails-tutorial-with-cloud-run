require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.create(:user)}
  let(:admin) {FactoryBot.create(:admin)}
  let(:active_user) {FactoryBot.create(:active_user)}


  it "nameが存在すること" do
    user.name = ""
    expect(user.valid?).to be_falsey
  end

  it "emailが存在すること" do
    user.email = ""
    expect(user.valid?).to be_falsey
  end

  it "emailが有効な形式であること" do
    user.email = "invalid_email"
    expect(user.valid?).to be_falsey
  end
  
  it "emailが一意であること" do
    user2 = User.create(name: "test user", email: user.email, password: "password", password_confirmation: "password")
    expect(user2.valid?).to be_falsey
  end

  it "digestを生成できること" do
    digest = User.digest(user.email)
    expect(digest.size).to  eq 60
  end

  it "remember_tokenを生成できること" do
    token = User.new_token
    expect(token.size).to  eq 22
  end

  context "管理者ユーザーの場合" do
    it "adminかどうかを判定できること" do
      expect(admin.admin?).to be_truthy
    end
  end

  context "有効化済みユーザーの場合" do
    it "activeかどうかを判定できること" do
      expect(active_user.activated?).to be_truthy
    end
  end

  context "有効化済みでないユーザーの場合" do
    it "activeがどうかを判定できること" do
      expect(user.activated?).to be_falsey
    end
  end

  describe "#remember,  #authenticated?" do
    it "remember_digestがデータベースに保存されていること" do
      user.remember
      expect(user.remember_digest).not_to be_nil
    end


    it "認証済みであればtrueを返すこと" do
      user.remember
      expect(user.authenticated?(:remember, user.remember_token)).to be_truthy
    end
  end

  context "新規ユーザーが作成された時" do
    it "activation emailが送信されること" do
      # todo
      pending "todo: add expectation"
      expect(true).to be false
    end
  
    context "activation emailのリンクをクリックしたとき" do
      it "ユーザーが有効化されること" do
        # todo
        pending "todo: add expectation"
        expect(true).to be false
      end
    end
  end

  


end
