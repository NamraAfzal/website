class Download < ApplicationRecord
  belongs_to :seller

  validates :resource_type, presence: true, inclusion: { in: %w[orders products] }

  scope :for_orders, -> { where(resource_type: 'orders') }
  scope :for_products, -> { where(resource_type: 'products') }
end
