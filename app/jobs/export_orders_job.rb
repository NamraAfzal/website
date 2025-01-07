require 'csv'

class ExportOrdersJob < ApplicationJob
  queue_as :default

  def perform(download_id, seller_id)
    download = Download.find(download_id)
    seller = Seller.find(seller_id)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << ["Order ID", "User ID", "User Name", "Shipping Address", "Amount", "Status", "Created At"]

      seller.orders.each do |order|
        csv << [
          order.id,
          order.user_id,
          order.user.name,
          order.shipping_address,
          order.amount,
          order.status,
          order.created_at.strftime("%Y-%m-%d %H:%M:%S")
        ]
      end
    end

    s3_client = Aws::S3::Resource.new(
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY'], ENV['SECRET_ACCESS_KEY'])
    )
    byebug
    bucket = s3_client.bucket('my-website2-bucket')
    file_name = "exports/seller_#{seller_id}_orders_#{Time.now.to_i}.csv"
    obj = bucket.object(file_name)
    obj.put(body: csv_data, acl: 'public-read')
    download.update!(file_url: obj.public_url, status: 'completed')
  rescue StandardError => e
    download.update!(status: 'failed')
    Rails.logger.error("ExportOrdersJob failed: #{e.message}")
  end
end
