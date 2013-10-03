require 's3_cors_fileupload/version'
require 's3_cors_fileupload/rails'

module S3CorsFileupload
  def self.active_record_protected_attributes?
    @active_record_protected_attributes ||= ActiveRecord::VERSION::STRING.to_f < 4.0 || !!defined?(ProtectedAttributes)
  end
end
