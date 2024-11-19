class Product < ApplicationRecord
  paginates_per 5
  belongs_to :seller
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, :price, presence: true
end
