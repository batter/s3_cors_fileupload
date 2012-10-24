module S3CorsFileupload
  module Rails
    class Engine < ::Rails::Engine
      initializer "s3_cors_fileupload.load_app_root_and_env" do |app|
         S3CorsFileupload.rails_root = app.root
         S3CorsFileupload.rails_env = app.env
      end
    end
  end
end
