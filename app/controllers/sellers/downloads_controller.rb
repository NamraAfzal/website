module Sellers
  class DownloadsController < ApplicationController
    before_action :authenticate_seller!

    def index
      @downloads = current_seller.downloads.order(created_at: :desc)
    end

    def create
      download = current_seller.downloads.create!(status: 'pending')
      ExportOrdersJob.perform_later(download.id, current_seller.id)
      redirect_to sellers_downloads_path, notice: "CSV export request submitted. It will be available shortly."
    end
  end
end
