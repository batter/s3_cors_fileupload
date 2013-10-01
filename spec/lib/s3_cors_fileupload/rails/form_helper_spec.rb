require 'spec_helper'

describe S3CorsFileupload::FormHelper do
  it { S3CorsFileupload::FormHelper.should be_instance_of(Module) }
  it { ActionView::Base.should include(S3CorsFileupload::FormHelper) }

  describe "Instance Methods" do
    subject { ActionView::Base.new }

    describe :s3_cors_fileupload_form_tag do
      it { should respond_to(:s3_cors_fileupload_form_tag) }

      it "should return HTML for the jQuery-File-Upload form" do
        value = subject.s3_cors_fileupload_form_tag
        value.should be_a(String)
        value.should be_instance_of(ActiveSupport::SafeBuffer)
        value.should be_html_safe
        value.match(/<form/).should_not be_nil
      end
    end

    describe :s3_cors_fileupload_form do
      it { should respond_to(:s3_cors_fileupload_form) }

      it "should be an alias for the `s3_cors_fileupload_form_tag` method" do
        subject.method(:s3_cors_fileupload_form).should == subject.method(:s3_cors_fileupload_form_tag)
      end
    end
  end
end
