require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) {FactoryBot.create(:user)}
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

end
