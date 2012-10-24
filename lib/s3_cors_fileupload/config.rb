require 'yaml'

module S3CorsFileupload
  AMAZON_S3_CONFIG = YAML.load_file(File.join(self.rails_root, 'config', 'amazon_s3.yml'))[self.rails_env]
end
