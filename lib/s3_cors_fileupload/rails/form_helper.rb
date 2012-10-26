module S3CorsFileupload
  module FormHelper
    # Options:
    # :access_key_id    The AWS Access Key ID of the owner of the bucket.
    #                   Defaults to the `Config.access_key_id` (read from the yaml config file).
    #
    # :acl              One of S3's Canned Access Control Lists, must be one of:
    #                   'private', 'public-read', 'public-read-write', 'authenticated-read'.
    #                   Defaults to `'public-read'`.
    #
    # :max_file_size    The max file size (in bytes) that you wish to allow to be uploaded.
    #                   Defaults to `Config.max_file_size` or, if no value is set on the yaml file `524288000` (500 MB)
    #
    # :bucket           The name of the bucket on S3 you wish for the files to be uploaded to.
    #                   Defaults to `Config.bucket` (read from the yaml config file).
    #
    # Any other key creates standard HTML options for the form tag.
    def s3_cors_fileupload_form_tag(options = {}, &block)
      policy_helper = PolicyHelper.new(options)
      # initialize the hidden form fields
      hidden_form_fields = {
        :key => '',
        'Content-Type' => '',
        'AWSAccessKeyId' => options[:access_key_id] || Config.access_key_id,
        :acl => policy_helper.options[:acl],
        :policy => policy_helper.policy_document,
        :signature => policy_helper.upload_signature,
        :success_action_status => '201'
      }
      # assume that all of the non-documented keys are 
      _html_options = options.reject { |key, val| [:access_key_id, :acl, :max_file_size, :bucket].include?(key) }
      # return the form html
      construct_form_html(hidden_form_fields, policy_helper.options[:bucket], _html_options,  &block)
    end
    
    private
    
    def build_form_options(options = {})
      { :id => 'fileupload' }.merge(options).merge(:multipart => true, :authenticity_token => false)
    end
    
    # hidden fields argument should be a hash of key value pairs (values may be blank if desired)
    def construct_form_html(hidden_fields, bucket, html_options = {}, &block)
      # now build the html for the form
      form_text = form_tag("https://#{bucket}.s3.amazonaws.com", build_form_options(html_options)) do
        hidden_fields.map do |name, value|
          hidden_field_tag(name, value)
        end.join.html_safe + "
        <!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->  
        <div class='row fileupload-buttonbar'>
          <div class='span7'>
            <button class='btn btn-success fileinput-button'>
              <i class='icon-plus icon-white'></i>
              <span>Add files...</span>
              ".html_safe +
              file_field_tag(:file, :multiple => true) + "
            </button>
            <button class='btn btn-primary start' type='submit'>
              <i class='icon-upload icon-white'></i>
              <span>Start upload</span>
            </button>
            <button class='btn btn-warning cancel' type='reset'>
              <i class='icon-ban-circle icon-white'></i>
              <span>Cancel upload</span>
            </button>
            <button class='btn btn-danger delete' type='button'>
              <i class='icon-trash icon-white'></i>
              <span>Delete</span>
            </button>
            <input class='toggle' type='checkbox'></input>
          </div>
          <div class='span5'>
            <!-- The global progress bar -->
            <div class='progress progress-success progress-striped active fade'>
              <div class='bar' style='width: 0%'></div>
            </div>
          </div>
        </div>
        <!-- The loading indicator is shown during image processing -->
        <div class='fileupload-loading'></div>
        <br>
        <!-- The table listing the files available for upload/download -->
        <table class='table table-striped' id='upload_files'>
          <tbody class='files' data-target='#modal-gallery' data-toggle='modal-gallery'></tbody>
        </table>".html_safe
      end
      form_text += capture(&block) if block
      form_text
    end
  end
end
