class Product < ApplicationRecord
  paginates_per 40
  has_one_attached :image
  belongs_to :seller
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, :price, :description, presence: true
  validates :image, presence: { message: "must be attached to the product" }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.ransackable_attributes(auth_object = nil)
    %w[id name price created_at updated_at category_id]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "image_attachments", "image_blobs", "order_items", "orders", "seller"]
  end

  def total_sales
    order_items.joins(:order).where(orders: { status: :placed }).sum("order_items.quantity")
  end
end
