class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  validates :jti, uniqueness: true
end
