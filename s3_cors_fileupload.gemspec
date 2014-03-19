# -*- encoding: utf-8 -*-
require File.expand_path('../lib/s3_cors_fileupload/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "s3_cors_fileupload"
  s.version     = S3CorsFileupload::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Ben Atkins"]
  s.email       = ["batkinz@gmail.com"]
  s.homepage    = "http://github.com/batter/s3_cors_fileupload"
  s.summary     = "File uploads for Rails >= 3.1 to AWS-S3 via CORS using the jQuery-File-Upload script"
  s.description = "Provides file uploads for Rails >= 3.1 to AWS-S3 via CORS using the jQuery-File-Upload javascript (via the asset pipeline)"
  s.licenses    = ["MIT"]

  s.required_ruby_version     = '>= 1.9'
  s.required_rubygems_version = '>= 1.8'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.extra_rdoc_files = %w(README.md CHANGELOG.md LICENSE.txt)
  s.rdoc_options = %w(--charset=UTF-8)

  s.add_dependency('rails', ['>= 3.1', '< 5.0'])
  s.add_dependency('multi_json', ['~> 1.0'])
  s.add_dependency('aws-s3', ['~> 0.6'])

  s.add_development_dependency('rake', ['>= 0.8.7'])
  s.add_development_dependency('bundler', ['>= 0'])
end
