# frozen_string_literal: true

require 'minitest/autorun'
require 'temporalio'

module TestHelper
end

def start_runtime
  runtime = Temporalio::Bridge::Runtime.new
  Thread.new do
    runtime.run_command_loop
  end
  runtime
end

def start_dev_server(runtime)
  queue = Queue.new
  Temporalio::Bridge::Testing::EphemeralServer.start_dev_server(runtime) { |val| queue.push(val) }
  server = queue.pop
  raise server if server.is_a? Temporalio::Bridge::Error

  server
end

$test_runtime = start_runtime
$test_server = start_dev_server($test_runtime)
Minitest.after_run do
  queue = Queue.new
  $test_server.shutdown { |val| queue.push(val) }
  res = queue.pop
  raise res if res.is_a? Temporalio::Bridge::Error
end
