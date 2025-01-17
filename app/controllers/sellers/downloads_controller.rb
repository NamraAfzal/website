module Sellers
  class DownloadsController < ApplicationController
    before_action :authenticate_seller!

    def index
      seller_download = current_seller.downloads
      @orders_downloads = seller_download.for_orders.order(created_at: :desc)
      @products_downloads = seller_download.for_products.order(created_at: :desc)
    end

    def create
      resource_type = params[:resource_type]
      capital_resource_type = resource_type.capitalize
      download = current_seller.downloads.create!(status: 'pending', resource_type:)
      "Export#{capital_resource_type}Job".constantize.perform_later(download.id, current_seller.id)
      flash[:notice] = "#{capital_resource_type} CSV export request submitted. It will be available shortly."
    rescue StandardError => e
      flash[:alert] = "#{capital_resource_type} failed: #{e.message}"
    ensure
      redirect_to sellers_downloads_path
    end
  end
end
