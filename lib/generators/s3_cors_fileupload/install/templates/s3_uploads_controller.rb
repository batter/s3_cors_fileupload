require 'base64'
require 'openssl'
require 'digest/sha1'

class S3UploadsController < ApplicationController

  helper_method :s3_upload_policy_document, :s3_upload_signature

  # GET /source_files
  # GET /source_files.json
  def index
    @source_files = SourceFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @source_files.map{|sf| sf.to_jq_upload } }
    end
  end

  # POST /source_files
  # POST /source_files.json
  def create
    @source_file = SourceFile.new(params[:source_file])
    respond_to do |format|
      if @source_file.save
        format.html {
          render :json => @source_file.to_jq_upload,
          :content_type => 'text/html',
          :layout => false
        }
        format.json { render json: @source_file.to_jq_upload, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @source_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /source_files/1
  # DELETE /source_files/1.json
  def destroy
    @source_file = SourceFile.find(params[:id])
    @source_file.destroy

    respond_to do |format|
      format.html { redirect_to source_files_url }
      format.json { head :no_content }
      format.xml { head :no_content }
    end
  end

  # used for s3_uploader
  def generate_key
    require 'uuidtools'
    uid = UUIDTools::UUID.timestamp_create.to_s.gsub(/-/,'')

    render json: {
      key: "uploads/#{uid}/#{params[:filename]}",
      success_action_redirect: "/"
    }
  end

  # ---- Helpers ----
  # generate the policy document that amazon is expecting.
  def s3_upload_policy_document
    Base64.encode64(
      {
        expiration: 1.hour.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
        conditions: [
          { bucket: AMAZON_S3_CONFIG['bucket'] },
          { acl: 'public-read' },
          { success_action_status: '201' },
          ["starts-with", "$key", ""],
          ["starts-with", "$Content-Type", ""]
        ]
      }.to_json
    ).gsub(/\n|\r/, '')
  end

  # sign our request by Base64 encoding the policy document.
  def s3_upload_signature
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest::Digest.new('sha1'),
        AMAZON_S3_CONFIG['secret_access_key'],
        s3_upload_policy_document
      )
    ).gsub(/\n/, '')
  end

end
