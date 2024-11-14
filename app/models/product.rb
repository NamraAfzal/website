class Product < ApplicationRecord
  paginates_per 5
  belongs_to :seller
  belongs_to :category

  validates :name, :price, presence: true
end
