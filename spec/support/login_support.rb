module LoginSupport
  module Request
    def login(user)
      post login_path, params: { session: { email: user.email, password: user.password}}
    end
  end

  module System
    def login(user)
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: user.password
      click_button "Log in"
    end
  end
end