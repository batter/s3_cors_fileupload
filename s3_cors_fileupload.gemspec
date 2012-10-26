# -*- encoding: utf-8 -*-
require File.expand_path('../lib/s3_cors_fileupload/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "s3_cors_fileupload"
  s.version     = S3CorsFileupload::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Atkins"]
  s.email       = ["benatkins@fullbridge.com"]
  s.homepage    = "http://github.com/fullbridge-batkins/s3_cors_fileupload"
  s.summary     = "File uploads for Rails ~> 3.1 to AWS-S3 via CORS using the jQuery-File-Upload script"
  s.description = "A gem for providing File uploads for Rails ~> 3.1 to AWS-S3 via CORS using the jQuery-File-Upload script"
  s.licenses    = ["MIT"]
  
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.rubygems_version = "1.8.24"
  
  s.add_dependency('rails', ['~> 3.1'])
  s.add_dependency('jquery-rails', ['>= 2.0'])
  s.add_dependency('aws-s3', ['~> 0.6']) # :require => 'aws/s3'
  
  s.add_development_dependency('rake', [">= 0.8.7"])
  s.add_development_dependency('bundler', [">= 0"])
  s.add_development_dependency('rdoc', ["~> 3.12"])
  s.add_development_dependency('jeweler', ["~> 1.8.4"])
  
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
end
