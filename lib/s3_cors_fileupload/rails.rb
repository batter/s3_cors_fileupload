module S3CorsFileupload
  class << self
    attr_accessor :rails_root
    attr_accessor :rails_env
  end
end

if defined?(::Rails)
  require 's3_cors_fileupload/rails/engine' if ::Rails.version >= '3.1'
  # require 's3_cors_fileupload/config'
  require 's3_cors_fileupload/policy_helper'
  require 's3_cors_fileupload/form_helper'

  ActionView::Base.send(:include, S3CorsFileupload::FormHelper) if defined?(ActionView::Base)
end
