require 'spec_helper'

describe S3CorsFileupload do
  
  it { should be_instance_of(Module) }
  
  # we will need to write some additional specs for the module within the context of a Rails app,
  # since much of the functionality doesn't get required unless Rails is defined.
end
