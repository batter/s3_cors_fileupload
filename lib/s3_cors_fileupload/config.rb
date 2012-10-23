require 'yaml'

module S3CorsFileupload
  AMAZON_S3_CONFIG = YAML.load_file("#{::Rails.root}/config/amazon_s3.yml")[::Rails.env]
end
