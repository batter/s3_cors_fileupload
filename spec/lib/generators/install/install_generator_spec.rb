require 'spec_helper'
require 'generator_spec/test_case'
require File.expand_path('../../../../../lib/generators/s3_cors_fileupload/install/install_generator', __FILE__)

describe S3CorsFileupload::Generators::InstallGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path('../../tmp', __FILE__)

  describe "no options" do
    before(:all) do
      prepare_destination
      # --setup a dummy routes file--
      mkdir_p ::File.dirname(::File.expand_path('../../tmp/config/routes.rb', __FILE__))
      copy_file ::File.expand_path('../../../../dummy/config/routes.rb', __FILE__), ::File.expand_path('../../tmp/config/routes.rb', __FILE__)
      # --
      run_generator
    end

    it "generates a config file" do
      destination_root.should have_structure {
        directory 'config' do
          file 'amazon_s3.yml' do
            contains 'defaults: &defaults'
            contains 'development:'
            contains 'test:'
            contains 'production:'
          end
        end
      }
    end

    it "generates a migration" do
      destination_root.should have_structure {
        directory 'db' do
          directory 'migrate' do
            migration 'create_source_files' do
              contains 'class CreateSourceFiles'
              contains 'def change'
              contains 'create_table :source_files do |t|'
            end
          end
        end
      }
    end

    it "generates a SourceFile model" do
      destination_root.should have_structure {
        directory 'app' do
          directory 'models' do
            file 'source_file.rb' do
              contains "require 'aws/s3'"
              contains 'class SourceFile < ActiveRecord::Base'
            end
          end
        end
      }
    end

    it "generates a controller and matching javascript asset" do
      destination_root.should have_structure {
        directory 'app' do
          directory 'controllers' do
            file 's3_uploads_controller.rb' do
              contains 'class S3UploadsController < ApplicationController'
            end
          end
        end
      }

      destination_root.should have_structure {
        directory 'app' do
          directory 'assets' do
            directory 'javascripts' do
              file 's3_uploads.js' do
                contains 's3-cors-file-upload'
                contains "$('#fileupload').bind('fileuploadadd', function (e, data) {"
                contains "$('#fileupload').bind('fileuploadsubmit', function (e, data) {"
                contains "$('#fileupload').bind('fileuploaddestroyed', function (e, data) {"
                contains 'function formatFileSize(bytes) {'
              end
            end
          end
        end
      }
    end

    it "generates view files (in ERB by default)" do
      destination_root.should have_structure {
        directory 'app' do
          directory 'views' do
            directory 's3_uploads' do
              Dir.foreach(File.expand_path("../../../../../lib/generators/s3_cors_fileupload/install/templates/views/erb", __FILE__)).reject { |file_name| %w(. ..).include?(file_name) }.each do |file_name|
                file file_name
              end
            end
          end
        end
      }
    end

    it "sets up routes" do
      _route_text = ["resources :source_files, :only => [:index, :create, :destroy], :controller => 's3_uploads' do", "\n",
                     "    get :generate_key, :on => :collection", "\n",
                     "  end"].join

      destination_root.should have_structure {
        directory 'config' do
          file 'routes.rb' do
            contains _route_text
          end
        end
      }
    end
  end # end of describe "no options" block

  describe "`migration` option set to `false`" do
    arguments %w(--skip-migration)
    before(:all) do
      prepare_destination
      # --setup a dummy routes file--
      mkdir_p ::File.dirname(::File.expand_path('../../tmp/config/routes.rb', __FILE__))
      copy_file ::File.expand_path('../../../../dummy/config/routes.rb', __FILE__), ::File.expand_path('../../tmp/config/routes.rb', __FILE__)
      # --
      run_generator
    end

    it "should not generate a migration" do
      destination_root.should have_structure {
        no_file 'db'
      }
    end
  end # end of describe "`migration` option set to `false`" block

  after(:all) { prepare_destination } # cleanup the tmp directory

end
