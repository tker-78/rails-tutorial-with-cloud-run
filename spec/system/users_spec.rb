require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  scenario "user signs up" do
    user = FactoryBot.build(:user)
    visit home_path
    click_link "Sign up new user"
    fill_in "Name", with: user.name
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    fill_in "Password confirmation", with: user.password
    click_button "Create my account"
    expect(page).to have_content("User created!")
  end
end
