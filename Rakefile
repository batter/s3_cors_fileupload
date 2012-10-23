# encoding: utf-8

require 'rubygems'
require 'bundler'
Bundler::GemHelper.install_tasks

require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "s3-cors-fileupload"
  gem.homepage = "http://github.com/fullbridge-batkins/s3-cors-fileupload"
  gem.license = "MIT"
  gem.summary = %q{File uploads for Rails 3.1 to AWS-S3 via CORS using the jQuery-File-Upload script}
  gem.description = %q{File uploads for Rails 3.1 to AWS-S3 via CORS using the jQuery-File-Upload script}
  gem.email = "benatkins@fullbridge.com"
  gem.authors = ["Ben Atkins"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

# If you want to make this the default task
task :default => :spec

# require 'rake/testtask'
# Rake::TestTask.new(:test) do |test|
#   test.libs << 'lib' << 'test'
#   test.pattern = 'test/**/test_*.rb'
#   test.verbose = true
# end
# 
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
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "s3-cors-fileupload #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
