require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record/migration'

module S3CorsFileupload
  class InstallGenerator < ::Rails::Generators::Base
    include Rails::Generators::Migration
    extend ActiveRecord::Generators::Migration
    extend ActiveRecord::Generators::ModelGenerator

    source_root File.expand_path('../templates', __FILE__)
    class_option :with_controller, :type => :boolean, :default => false, :desc => "Store changeset (diff) with each version"

    desc 'Generates (but does not run) a migration to add a source_files table, and a corresponding model,
          as well as a controller, routes, and views for the file uploading.'

    def create_migration_file
      migration_template 'create_source_files.rb', 'db/migrate/create_source_files.rb'
    end
    
    def create_model_file
      copy_file 'source_file.rb', 'app/models/source_file.rb'
    end
    
    def create_controller
      # if options.with_controller?
      copy_file 's3_uploads_controller.rb', 'app/controllers/s3_uploads_controller.rb'
      copy_file 's3_uploads.js', 'app/assets/javascripts/s3_uploads.js'
    end
    
    def create_views
      Dir.mkdir("#{::Rails.root}/app/views/s3_uploads") unless File.directory?("#{::Rails.root}/app/views/s3_uploads")
      Dir.foreach('./templates/views').reject { |file_name| %w(. ..).include?(file_name) }.each do |file_name|
        copy_file file_name, "app/views/s3_uploads/#{file_name}"
      end
    end
    
    def setup_routes
      route('add_gem_routes')
    end
    
  end
end

module ActionDispatch::Routing
  class Mapper
    def add_gem_routes
      #routing code...
    end
  end
end
