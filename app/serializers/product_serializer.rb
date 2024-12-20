class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :stock, :category_id, :image_url, :seller_id

  def image_url
    object.image.attached? ? Rails.application.routes.url_helpers.url_for(object.image) : nil
  end
end
