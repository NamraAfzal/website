require 'csv'
class ExportProductsJob < ApplicationJob
  queue_as :default

  def perform(download_id, seller_id)
    seller = Seller.find(seller_id)
    download = Download.find(download_id)

    headers = %w[Name Category Price Stock]
    rows = seller.products.map do |product|
      [product.name, product.category&.name, product.price, product.stock]
    end
    csv_data = CsvService.generate_csv(headers, rows)

    file_name = "exports/seller_#{seller_id}_products_#{Time.now.to_i}.csv"
    file_url = S3UploadService.upload_to_s3(file_name, csv_data)

    download.update!(file_url:, status: 'completed')
  rescue StandardError => e
    download.update!(status: 'failed')
    Rails.logger.error("ExportProductsJob failed: #{e.message}")
  end
end
