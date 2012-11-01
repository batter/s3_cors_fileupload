# encoding: utf-8

require 'rubygems'
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

task :default => :spec

# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
#   test.libs << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
#   test.rcov_opts << '--exclude "gems/*"'
# end
# 
# task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  require File.expand_path('../lib/s3_cors_fileupload/version', __FILE__)

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "S3CorsFileupload #{S3CorsFileupload::VERSION}"
  rdoc.rdoc_files.include('LICENSE*')
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('CHANGELOG*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Open an irb session preloaded with this library'
task :console do
  sh 'irb -I lib -r s3_cors_fileupload.rb'
end
