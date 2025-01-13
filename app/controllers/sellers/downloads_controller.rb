module Sellers
  class DownloadsController < ApplicationController
    before_action :authenticate_seller!

    def index
      @orders_downloads = current_seller.downloads.for_orders.order(created_at: :desc)
      @products_downloads = current_seller.downloads.for_products.order(created_at: :desc)
    end

    def create
      resource_type = params[:resource_type]
      download = current_seller.downloads.create!(status: 'pending', resource_type: resource_type)

      if resource_type == 'orders'
        ExportOrdersJob.perform_later(download.id, current_seller.id)
      elsif resource_type == 'products'
        ExportProductsJob.perform_later(download.id, current_seller.id)
      else
        redirect_to sellers_downloads_path, alert: 'Invalid resource type.' and return
      end

      redirect_to sellers_downloads_path, notice: "#{resource_type.capitalize} CSV export request submitted. It will be available shortly."
    end
  end
end
