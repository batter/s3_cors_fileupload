require 'spec_helper'
require 'generator_spec/test_case'
require File.expand_path('../../../../../lib/generators/s3_cors_fileupload/install/install_generator', __FILE__)


# for some reason, this was throwing errors when it was in the main install_generator_spec file.
# that's why it has it's own spec file.
describe S3CorsFileupload::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../../tmp', __FILE__)

  describe "`template-language` option set to `haml`" do
    arguments %w(--template-language=haml)
    before(:all) do
      prepare_destination
      # --setup a dummy routes file--
      mkdir_p ::File.dirname(::File.expand_path('../../tmp/config/routes.rb', __FILE__))
      copy_file ::File.expand_path('../../../../dummy/config/routes.rb', __FILE__), ::File.expand_path('../../tmp/config/routes.rb', __FILE__)
      # --
      run_generator
    end

    it "generates view files (in HAML)" do
      destination_root.should have_structure {
        directory 'app' do
          directory 'views' do
            directory 's3_uploads' do
              Dir.foreach(File.expand_path("../../../../../lib/generators/s3_cors_fileupload/install/templates/views/haml", __FILE__)).reject { |file_name| %w(. ..).include?(file_name) }.each do |file_name|
                file file_name
              end
            end
          end
        end
      }
    end
  end # end of "`template-language` option set to `haml`" block

  after(:all) { prepare_destination } # cleanup the tmp directory

end
