require 'spec_helper'
require 'ffaker'

describe S3CorsFileupload::Config do
  subject { S3CorsFileupload::Config }

  it { should be_instance_of(Module) }

  describe :method_missing do
    context "arguments received" do
      it "should raise a NoMethodError" do
        expect { subject.foobar(:arg) }.to raise_error(NoMethodError)
        expect { subject.access_key_id(:hai) }.to raise_error(NoMethodError)
      end
    end

    context "block received" do
      it "should raise a NoMethodError" do
        expect { subject.foobar { :foobar } }.to raise_error(NoMethodError)
        expect { subject.access_key_id { :block } }.to raise_error(NoMethodError)
      end
    end

    context "no arguments or block received" do
      context "key doesn't exist on `config/amazon_s3.yml`" do
        its(:foobar) { should be_nil }
        10.times do
          its(FFaker::Lorem.word.to_sym) { should be_nil }
        end
      end

      context "key exists on `config/amazon_s3.yml`" do
        describe "it should return the value associated with the key" do
          its(:access_key_id) { should == 'your_access_key_id' }
          its(:secret_access_key) { should == 'your_secret_access_key' }
          its(:acl) { should == 'public-read' }
          its(:max_file_size) { should == 524288000 }
          its(:bucket) { should == 'your_development_bucket_name' }
        end
      end
    end
  end
end
