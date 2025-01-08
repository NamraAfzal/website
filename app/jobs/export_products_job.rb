require 'csv'
class ExportProductsJob < ApplicationJob
  queue_as :default

  def perform(download_id, seller_id)
    seller = Seller.find(seller_id)
    download = Download.find(download_id)

    csv_data = CSV.generate(headers: true) do |csv|
      csv << %w[Name Category Price Stock]
      seller.products.find_each do |product|
        csv << [product.name, product.category&.name, product.price, product.stock]
      end
    end

    s3_client = Aws::S3::Resource.new(
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY'], ENV['SECRET_ACCESS_KEY'])
    )
    bucket = s3_client.bucket('my-website2-bucket')
    file_name = "exports/seller_#{seller_id}_products_#{Time.now.to_i}.csv"
    obj = bucket.object(file_name)
    obj.put(body: csv_data, acl: 'public-read')
    download.update!(file_url: obj.public_url, status: 'completed')
  rescue
    download.update!(status: 'failed')
    Rails.logger.error("ExportProductsJob failed: #{e.message}")
  end
end
