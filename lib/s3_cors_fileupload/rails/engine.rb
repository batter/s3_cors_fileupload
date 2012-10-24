require 'yaml'

module S3CorsFileupload
  module Rails
    class Engine < ::Rails::Engine
      initializer "s3_cors_fileupload.load_s3_config", :after => :add_generator_templates do |app|
        if File.exists? File.join(::Rails.root, 'config', 'amazon_s3.yml')
          S3CorsFileupload.const_set('AMAZON_S3_CONFIG', YAML.load_file(File.join(::Rails.root, 'config', 'amazon_s3.yml'))[::Rails.env])
        else
          warn('WARNING: s3_cors_fileupload gem was unable to locate a configuration file in config/amazon_s3.yml and may not ' +
                'be able to function properly.  Please run `rails generate s3_cors_upload:install` before proceeding.')
        end
      end
    end
  end
end
