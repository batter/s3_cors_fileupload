source :rubygems

group :development do
  gem 'rdoc', '~> 3.12'
  gem 'gem-release', '~> 0.4'
end

group :test do
  gem 'rspec-rails', '~> 2.12'
  gem 'shoulda-matchers'
  gem 'generator_spec'
  gem 'ffaker'

  # dependencies for S3CorsFileUpload
  gem 'rails', '~> 3.2'
  # gem 'jquery-rails' # would be necessary to do UI testing on the dummy app
  gem 'sqlite3' # the database driver for rails
  gem 'aws-s3', :require => 'aws/s3'
end
