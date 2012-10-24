require 'yaml'

module S3CorsFileupload
  module Rails
    class Engine < ::Rails::Engine
      initializer "Load the YAML config file into a constant" do |app|
         S3CorsFileupload.const_set('AMAZON_S3_CONFIG', YAML.load_file(File.join(::Rails.root, 'config', 'amazon_s3.yml'))[::Rails.env])
      end
    end
  end
end
