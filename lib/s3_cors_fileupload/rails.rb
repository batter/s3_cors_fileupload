if defined?(::Rails)
  require 's3_cors_fileupload/rails/config'
  require 's3_cors_fileupload/rails/engine' if ::Rails.version >= '3.1'
  require 's3_cors_fileupload/rails/policy_helper'
  require 's3_cors_fileupload/rails/form_helper'

  ActionView::Base.send(:include, S3CorsFileupload::FormHelper) if defined?(ActionView::Base)
end
