require 'csv'
class ExportOrdersJob < ApplicationJob
  queue_as :default

  def perform(download_id, seller_id)
    download = Download.find(download_id)
    seller = Seller.find(seller_id)

    headers = ["Order ID", "User ID", "User Name", "Shipping Address", "Amount", "Status", "Created At"]
    rows = seller.orders.map do |order|
      [
        order.id,
        order.user_id,
        order.user.name,
        order.shipping_address,
        order.amount,
        order.status,
        order.created_at.strftime("%Y-%m-%d %H:%M:%S")
      ]
    end
    csv_data = CsvService.generate_csv(headers, rows)

    file_name = "exports/seller_#{seller_id}_orders_#{Time.now.to_i}.csv"
    file_url = S3UploadService.upload_to_s3(file_name, csv_data)

    download.update!(file_url:, status: 'completed')
  rescue StandardError => e
    download.update!(status: 'failed')
    Rails.logger.error("ExportOrdersJob failed: #{e.message}")
  end
end
