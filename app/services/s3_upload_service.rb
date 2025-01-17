require 'aws-sdk-s3'

class S3UploadService
  def self.upload_to_s3(file_name, file_body)
    s3_client = Aws::S3::Resource.new(
      region: 'us-east-1',
      credentials: Aws::Credentials.new(ENV['ACCESS_KEY'], ENV['SECRET_ACCESS_KEY'])
    )
    bucket = s3_client.bucket('my-website2-bucket')
    obj = bucket.object(file_name)
    obj.put(body: file_body, acl: 'public-read')
    obj.public_url
  end
end
