require 'spec_helper'

describe S3CorsFileupload do

  describe "Constants" do
    describe :VERSION do
      it { S3CorsFileupload.const_defined?(:VERSION).should be_true }
    end
    describe :JQUERY_FILEUPLOAD_VERSION do
      it { S3CorsFileupload.const_defined?(:JQUERY_FILEUPLOAD_VERSION).should be_true }
    end
    describe :JQUERY_FILEUPLOAD_UI_VERSION do
      it { S3CorsFileupload.const_defined?(:JQUERY_FILEUPLOAD_UI_VERSION).should be_true }
    end
  end

end
