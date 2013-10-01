require 'spec_helper'

describe S3CorsFileupload::Rails::Engine do
  subject { S3CorsFileupload::Rails::Engine }

  it { should be_instance_of(Class) }
  its(:superclass) { should == ::Rails::Engine }
end
