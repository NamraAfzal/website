class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :orders, dependent: :destroy
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :jwt_authenticatable, jwt_revocation_strategy: self

  validate :password_complexity

  private

  def password_complexity
      if password.present? && (password.length > 10 || password !~ /[!@#$%^&*]/)
        errors.add :password, 'must be 10 characters or less and include at least one special character (!@#$%^&*).'
      end
  end
end
