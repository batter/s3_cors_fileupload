# encoding: utf-8

require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
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
  version = S3CorsFileupload::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "s3_cors_fileupload #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "Open an irb session preloaded with this library"
task :console do
  sh "irb -I lib -r s3_cors_fileupload.rb"
end
