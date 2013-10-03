require 'spec_helper'

describe S3CorsFileupload do
  it { should be_instance_of(Module) }

  describe "Methods" do
    describe :active_record_protected_attributes? do
      it { should respond_to(:active_record_protected_attributes?) }

      its(:active_record_protected_attributes?) { should be_false } # Since the dummy app isn't using `ProtectedAttributes`
    end
  end
end
