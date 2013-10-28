require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module S3CorsFileupload
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include ::Rails::Generators::Migration

      VALID_TEMPLATE_LANGS = [:erb, :haml]

      source_root File.expand_path('../templates', __FILE__)
      class_option :migration, :type => :boolean, :default => true, :desc => "Generate a migration for the SourceFile model."
      class_option :template_language, :type => :string, :default => 'erb', :desc => "Specify a template language to use for view files, must be one of: [erb, haml]"

      desc('Creates a config file, then generates (but does not run) a migration to add a source_files table and ' +
            'a corresponding model, as well as a controller, routes, and views for the file uploading.')

      def create_config_file
        copy_file 'amazon_s3.yml', 'config/amazon_s3.yml'
      end

      def create_migration_file
        migration_template 'create_source_files.rb', 'db/migrate/create_source_files.rb' if options.migration?
      end

      def create_model_file
        adapter = defined?(Mongoid) ? 'mongoid' : 'active_record'
        copy_file "models/#{adapter}/source_file.rb", 'app/models/source_file.rb'
      end

      def create_controller
        copy_file 's3_uploads_controller.rb', 'app/controllers/s3_uploads_controller.rb'
        copy_file 's3_uploads.js', 'app/assets/javascripts/s3_uploads.js'
      end

      def create_views
        template_language = options.template_language if VALID_TEMPLATE_LANGS.include?(options.template_language.to_sym)
        template_language ||= 'erb'
        Dir.foreach(File.expand_path("../templates/views/#{template_language}", __FILE__)).reject { |file_name| %w(. ..).include?(file_name) }.each do |file_name|
          copy_file "views/#{template_language}/#{file_name}", "app/views/s3_uploads/#{file_name}"
        end
      end

      def setup_routes
        route(
          ["resources :source_files, :only => [:index, :create, :destroy], :controller => 's3_uploads' do", "\n",
        "    get :generate_key, :on => :collection", "\n",
        "  end"].join
        )
      end

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end

    end
  end
end
