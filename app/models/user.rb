class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  has_secure_password
  validates :name, presence: true
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: true
  attr_accessor :remember_token, :activation_token, :reset_token # not saved in database
  before_create :create_activation_digest

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost # default cost is 12
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # remember_tokenをdigest化して、データベースに保存する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil) # dbから削除
  end

  # user activation
  def activate
    update_attribute(:activated, true) # dbに保存
    update_attribute(:activated_at, Time.zone.now) # dbに保存
  end

  # 渡されたトークンがダイジェストと一致したらtrueを返す
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    self.reset_digest = User.digest(reset_token)
    update_attribute(:reset_digest, reset_digest) # dbに保存する
    update_attribute(:reset_sent_at, Time.zone.now) # dbに保存する
  end



  private
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end


end
