class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[id order_id product_id quantity created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order product]
  end
end
