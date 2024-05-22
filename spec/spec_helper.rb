# frozen_string_literal: true

require 'temporalio'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Start and stop an ephemeral server

  config.before(:suite) do
    $test_server = nil
    $test_runtime = Temporalio::Bridge::Runtime.new
    Thread.new do
      $test_runtime.run_command_loop
    end

    queue = Queue.new
    Temporalio::Bridge::Testing::EphemeralServer.start_dev_server($test_runtime) { |val| queue.push(val) }
    server = queue.pop
    raise server if server.is_a? Temporalio::Bridge::Error

    $test_server = server
  end

  config.after(:suite) do
    if $test_server
      queue = Queue.new
      $test_server.shutdown { |val| queue.push(val) }
      res = queue.pop
      raise res if res.is_a? Temporalio::Bridge::Error
    end
  end
end
