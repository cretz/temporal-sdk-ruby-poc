# frozen_string_literal: true

require_relative 'lib/temporalio/version'

Gem::Specification.new do |spec|
  spec.name = 'temporalio'
  spec.version = Temporalio::VERSION
  spec.authors = ['Chad Retz']
  spec.email = ['chad@temporal.io']

  spec.summary = 'Some short summary'
  spec.description = 'Some long description'
  spec.homepage = 'https://github.com/cretz/temporal-sdk-ruby-poc'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'
  spec.required_rubygems_version = '>= 3.3.11'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/cretz/temporal-sdk-ruby-poc'

  spec.files = Dir['lib/**/*.rb', 'ext/**/*.{rs,rb}', '**/Cargo.*', 'LICENSE.txt', 'README.md']
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.extensions = ['ext/Cargo.toml']
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'google-protobuf', '>= 3.21.1'

  spec.add_development_dependency 'async'
  spec.add_development_dependency 'grpc'
  spec.add_development_dependency 'grpc-tools'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rake-compiler'
  spec.add_development_dependency 'rb_sys', '~> 0.9.63'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
