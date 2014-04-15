require 'spec_helper'

describe S3CorsFileupload::PolicyHelper do
  it { S3CorsFileupload::PolicyHelper.should be_instance_of(Class) }

  let(:options) { {} }
  let(:policy_helper) { S3CorsFileupload::PolicyHelper.new(options) }

  describe "Constructor" do
    context "no arguments" do
      it "should build without error" do
        policy_helper
      end

      it "should use default values" do
        policy_helper.options[:acl].should == 'public-read'
        policy_helper.options[:max_file_size].should == S3CorsFileupload::Config.max_file_size || 524288000
        policy_helper.options[:bucket].should == S3CorsFileupload::Config.bucket
        policy_helper.options[:secret_access_key].should == S3CorsFileupload::Config.secret_access_key
      end
    end

    context "arguments" do
      context :acl do
        let(:options) { {:acl => 'private'} }
        it { policy_helper.options[:acl].should == 'private' }
      end

      context :max_file_size do
        let(:options) { {:max_file_size => 10} }
        it { policy_helper.options[:max_file_size].should == 10 }
      end

      context :bucket do
        let(:options) { {:bucket => 'foobar'} }
        it { policy_helper.options[:bucket].should == 'foobar' }
      end

      context :bucket do
        let(:options) { {:bucket => 'foobar'} }
        it { policy_helper.options[:bucket].should == 'foobar' }
      end
    end

    context "missing required configuration options" do
      context "missing bucket" do
        before { S3CorsFileupload::Config.stub(:bucket) { '' } }

        it 'raises a meaningful error' do
          expect {
            policy_helper
          }.to raise_error(S3CorsFileupload::Config::MissingOptionError,
                           "bucket is a required option in #{S3CorsFileupload::Config.path}")
        end
      end

      context "missing secret_access_key" do
        before { S3CorsFileupload::Config.stub(:secret_access_key) { '' } }

        it 'raises a meaningful error' do
          expect {
            policy_helper
          }.to raise_error(S3CorsFileupload::Config::MissingOptionError,
                           "secret_access_key is a required option in #{S3CorsFileupload::Config.path}")
        end
      end
    end
  end

  describe "Instance Methods" do
    describe :policy_document do
      it { should respond_to(:policy_document) }

      it "should generate a policy document for AWS S3 and use `Base64` to encode it" do
        value = policy_helper.policy_document
        value.should be_instance_of(String)
        # decode and then deserialize the value returned from the policy document
        value = MultiJson.load Base64.decode64(value), symbolize_keys: true
        value.should be_instance_of(Hash)
        value.should have_key(:expiration)
        value.should have_key(:conditions)
        value[:conditions].should == [
            { bucket: policy_helper.options[:bucket] },
            { acl: policy_helper.options[:acl] },
            { success_action_status: '201' },
            ["content-length-range", 0, policy_helper.options[:max_file_size]],
            ["starts-with", "$utf8", ""],
            ["starts-with", "$key", ""],
            ["starts-with", "$Content-Type", ""]
          ]
      end

      it "should cache the return value in an instance variable" do
        policy_helper.instance_variable_get(:@policy_document).should be_nil
        value = policy_helper.policy_document
        policy_helper.instance_variable_get(:@policy_document).should_not be_nil
        policy_helper.instance_variable_get(:@policy_document).should == value
      end
    end

    describe :upload_signature do
      it { should respond_to(:upload_signature) }

      it "should create an upload signature based off our secret_access_key, and convert it to a string" do
        policy_helper.upload_signature.should == Base64.encode64(
            OpenSSL::HMAC.digest(OpenSSL::Digest::SHA1.new, policy_helper.options[:secret_access_key], policy_helper.policy_document)
          ).gsub(/\n/, '')
      end

      it "should cache the return value in an instance variable" do
        policy_helper.instance_variable_get(:@upload_signature).should be_nil
        value = policy_helper.upload_signature
        policy_helper.instance_variable_get(:@upload_signature).should_not be_nil
        policy_helper.instance_variable_get(:@upload_signature).should == value
      end
    end
  end

end
