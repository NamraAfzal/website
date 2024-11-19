class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  enum status: {
    cart: 0,
    placed: 1,
    confirmed: 2,
    shipped: 3
  }

  validates :status, presence: true

  before_create :set_default_status

  private

  def set_default_status
    self.status ||= :cart
  end
end
