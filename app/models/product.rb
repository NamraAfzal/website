class Product < ApplicationRecord
  paginates_per 5
  has_many_attached :images
  validate :validate_images_count
  belongs_to :seller
  belongs_to :category
  has_many :order_items
  has_many :orders, through: :order_items

  validates :name, :price, presence: true
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private

  def validate_images_count
    if images.count > 5
      errors.add(:images, "cannot have more than 5 images.")
    end
  end
end
