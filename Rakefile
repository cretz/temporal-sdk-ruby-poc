# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rb_sys/extensiontask'
require 'rb_sys/cargo/metadata'

task build: :compile

GEMSPEC = Gem::Specification.load('temporalio.gemspec')

RbSys::ExtensionTask.new('temporalio_bridge', GEMSPEC) do |ext|
  ext.lib_dir = 'lib/temporalio'
end

require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.warning = false
  t.libs << 'test'
  t.libs << 'lib'
  t.test_files = FileList['test/**/*_test.rb']
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new

require 'steep/rake_task'

Steep::RakeTask.new

require 'fileutils'

namespace :proto do
  desc 'Generate API and Core protobufs'
  task :generate do
    # Remove all existing
    FileUtils.rm_rf('lib/temporalio/api')

    # Collect set of API protos with Google ones removed
    api_protos = Dir.glob('ext/sdk-core/sdk-core-protos/protos/api_upstream/**/*.proto').reject do |proto|
      proto.include?('google')
    end

    # Generate API to temp dir and move
    FileUtils.rm_rf('tmp-proto')
    FileUtils.mkdir_p('tmp-proto')
    sh 'bundle exec grpc_tools_ruby_protoc ' \
       '--proto_path=ext/sdk-core/sdk-core-protos/protos/api_upstream ' \
       '--ruby_out=tmp-proto ' \
       "#{api_protos.join(' ')}"

    # Walk all generated Ruby files and cleanup content and filename
    Dir.glob('tmp-proto/temporal/api/**/*.rb') do |path|
      # Fix up the import
      content = File.read(path)
      content.gsub!(%r{^require 'temporal/(.*)_pb'$}, "require 'temporalio/\\1'")
      File.write(path, content)

      # Remove _pb from the filename
      FileUtils.mv(path, path.sub('_pb', ''))
    end

    # Move from temp dir and remove temp dir
    FileUtils.mv('tmp-proto/temporal/api', 'lib/temporalio')
    FileUtils.rm_rf('tmp-proto')

    # Write files that will help with imports. We are requiring the
    # request_response and not the service because the service depends on Google
    # API annotations we don't want to have to depend on.
    string_lit = "# frozen_string_literal: true\n\n"
    File.write(
      'lib/temporalio/api/workflowservice.rb',
      "#{string_lit}require 'temporalio/api/workflowservice/v1/request_response'\n"
    )
    File.write(
      'lib/temporalio/api/operatorservice.rb',
      "#{string_lit}require 'temporalio/api/operatorservice/v1/request_response'\n"
    )
    File.write(
      'lib/temporalio/api.rb',
      "#{string_lit}require 'temporalio/api/operatorservice'\nrequire 'temporalio/api/workflowservice'\n"
    )
  end
end

namespace :rbs do
  desc 'RBS tasks'
  task :install_collection do
    sh 'rbs collection install'
  end
end

task default: [:rubocop, 'rbs:install_collection', :steep, :compile, :test]
