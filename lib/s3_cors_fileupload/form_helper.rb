module S3CorsFileupload
  module FormHelper
    def s3_cors_fileupload_form(options = {}, &block)
      policy_helper = PolicyHelper.new(options)
      # initialize the hidden form fields
      hidden_form_fields = {
        :key => '',
        'AWSAccessKeyId' => options[:access_key_id] || AMAZON_S3_CONFIG['access_key_id'],
        :acl => policy_helper.options[:acl],
        :policy => policy_helper.policy_document,
        :signature => policy_helper.upload_signature,
        :success_action_status => '201'
      }
      construct_form_html(hidden_form_fields, &block)
    end
    
    private
    
    def build_form_options(options = {})
      {
        :id = 'fileupload',
        :method => 'post',
        :multipart => true,
        :authenticity_token => false
      }
    end
    
    # hidden fields argument should be a hash of key value pairs (values can be left blank if desired)
    def construct_form_html(hidden_fields, &block)
      # determine if a bucket argument was passed in
      bucket = form_options[:bucket] || AMAZON_S3_CONFIG['bucket']
      # now build the html for the form
      form_text = form_tag("https://#{AMAZON_S3_CONFIG['bucket']}.s3.amazonaws.com", build_form_options) do
        hidden_form_fields.map do |name, value|
          hidden_field_tag(name, value)
        end.join.html_safe +
        "<!-- The fileupload-buttonbar contains buttons to add/delete files and start/cancel the upload -->  
        <div class='row fileupload-buttonbar'>
          <div class='span7'>
            <button class='btn btn-success fileinput-button'>
              <i class='icon-plus icon-white'></i>
              <span>Add files...</span>".html_safe +
              file_field_tag(:file, :multiple => true) +
            "</button>
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
