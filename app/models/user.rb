class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
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
