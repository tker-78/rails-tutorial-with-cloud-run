# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:8080/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.new
    user.name = "nanana"
    user.email = "nanana@gmail.com"
    user.password = "password"
    user.password_confirmation = "password"

    user.activation_token = User.new_token
    UserMailer.account_activation(user).deliver_now
  end

  # Preview this email at http://localhost:8080/rails/mailers/user_mailer/password_reset
  def password_reset
    user = User.new
    user.name = "nanana"
    user.email = "nanana@gmail.com"
    user.password = "password"
    user.password_confirmation = "password"

    user.reset_token = User.new_token
    UserMailer.password_reset(user)
  end

end
