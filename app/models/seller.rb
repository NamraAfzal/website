class Seller < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  has_many :products
  has_many :orders, through: :products
  has_many :downloads
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self


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
