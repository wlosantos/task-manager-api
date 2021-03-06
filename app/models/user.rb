class User < ApplicationRecord

  has_many :tasks, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable
         include DeviseTokenAuth::Concerns::User

  validates_uniqueness_of :auth_token

  before_create :generate_authentication_token!

  def info
    "#{email} - #{created_at} - Token: #{Devise.friendly_token}"
  end

  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while User.exists?(auth_token)
  end

end
