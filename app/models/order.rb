class Order < ApplicationRecord
  enum status: { cart: 0,placed: 1,confirmed: 2,shipped: 3 }
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status, presence: true

  before_create :set_default_status

  scope :for_seller, ->(seller) {
    joins(:order_items).where(order_items: { product_id: seller.products.select(:id) }).distinct
  }

  def self.ransackable_attributes(auth_object = nil)
    %w[id status created_at updated_at user_id]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[order_items user]
  end

  private

  def set_default_status
    self.status ||= :cart
  end
end
