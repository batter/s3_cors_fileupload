require 'aws/s3'

class SourceFile < ActiveRecord::Base
  attr_accessible :url, :bucket, :key

  validates_presence_of :file_name, :file_content_type, :file_size, :key, :bucket

  before_validation(:on => :create) do
    self.file_name = key.split('/').last if key
    # for some reason, the response from AWS seems to escape the slashes in the keys, this line will unescape the slash
    self.url = url.gsub(/%2F/, '/') if url
    # Rails 4 introduces the `try!` method, which is required in this instance, since the `size` and `content_type` methods are not
    # explicitly defined on an `AWS::S3::S3Object` class.
    self.file_size ||= s3_object.respond_to?(:try!) ? s3_object.try!(:size) : s3_object.try(:size)
    self.file_content_type ||=  s3_object.respond_to?(:try!) ? s3_object.try!(:content_type) : s3_object.try(:content_type)
  end
  # make all attributes readonly after creating the record (not sure we need this?)
  after_create { readonly! }
  # cleanup; destroy corresponding file on S3
  after_destroy { s3_object.try(:delete) }

  def to_jq_upload
    { 
      'id' => id,
      'name' => file_name,
      'size' => file_size,
      'url' => url,
      'image' => self.is_image?,
      'delete_url' => Rails.application.routes.url_helpers.source_file_path(self, :format => :json)
    }
  end

  def is_image?
    !!file_content_type.try(:match, /image/)
  end

  #---- start S3 related methods -----
  def s3_object
    @s3_object ||= AWS::S3::S3Object.find(key, bucket) if self.class.open_aws && key
  rescue
    nil
  end

  def self.open_aws
    unless @aws_connected
      AWS::S3::Base.establish_connection!(
        :access_key_id     => S3CorsFileupload::Config.access_key_id,
        :secret_access_key => S3CorsFileupload::Config.secret_access_key
      )
    end
    @aws_connected ||= AWS::S3::Base.connected?
  end
  #---- end S3 related methods -----

end
