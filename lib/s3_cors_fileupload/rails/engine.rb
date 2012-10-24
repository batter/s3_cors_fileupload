require 'yaml'

module S3CorsFileupload
  module Rails
    class Engine < ::Rails::Engine
      initializer "Load the YAML config file into a constant" do |app|
         # S3CorsFileupload.rails_root = app.root
         # S3CorsFileupload.rails_env = app.env
         S3CorsFileupload.const_set('AMAZON_S3_CONFIG', YAML.load_file(File.join(app.root, 'config', 'amazon_s3.yml'))[app.env])
      end
    end
  end
end
