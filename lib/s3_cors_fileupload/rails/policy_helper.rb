require 'base64'
require 'openssl'
require 'digest/sha1'
require 'json'

module S3CorsFileupload
  class PolicyHelper
    attr_reader :options

    def initialize(_options = {})
      # default max_file_size to 500 MB if nothing is received
      @options = {
        :acl => 'public-read',
        :max_file_size => Config.max_file_size || 524288000,
        :bucket => Config.bucket
      }.merge(_options).merge(:secret_access_key => Config.secret_access_key)
    end

    # generate the policy document that amazon is expecting.
    def policy_document
      Base64.encode64(
        {
          expiration: 1.hour.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z'),
          conditions: [
            { bucket: options[:bucket] },
            { acl: options[:acl] },
            { success_action_status: '201' },
            ["content-length-range", 0, options[:max_file_size]],
            ["starts-with", "$utf8", ""],
            ["starts-with", "$key", ""],
            ["starts-with", "$Content-Type", ""]
          ]
        }.to_json
      ).gsub(/\n|\r/, '')
    end

    # sign our request by Base64 encoding the policy document.
    def upload_signature
      Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest::Digest.new('sha1'),
          options[:secret_access_key],
          self.policy_document
        )
      ).gsub(/\n/, '')
    end
  end
end
