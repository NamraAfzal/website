class User < ApplicationRecord
  has_many :orders, dependent: :destroy
  has_one :address, dependent: :destroy
  accepts_nested_attributes_for :address
  # after_create :initialize_cart
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  validate :password_complexity

  private

  def password_complexity
      if password.present? && (password.length > 10 || password !~ /[!@#$%^&*]/)
        errors.add :password, 'must be 10 characters or less and include at least one special character (!@#$%^&*).'
      end
  end
end
