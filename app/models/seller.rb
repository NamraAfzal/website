class Seller < ApplicationRecord
  has_many :products
  has_many :orders, through: :products
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def total_orders
    products.joins(:order_items).distinct.count('order_items.order_id')
  end

  def total_products
    products.count
  end

  def total_sales
    products.joins(:order_items).sum("order_items.quantity")
  end

  def total_revenue
    products.joins(:order_items).sum("order_items.quantity * products.price")
  end
end
