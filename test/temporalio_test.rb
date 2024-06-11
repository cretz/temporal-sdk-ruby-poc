# frozen_string_literal: true

require 'async'
require 'test_helper'
require 'temporalio'

class TemporalioTest < Minitest::Test
  include TestHelper

  def test_version_number
    assert !Temporalio::VERSION.nil?
  end

  def test_start_workflows_threaded
    start_workflows
  end

  def test_start_workflows_async
    Sync do
      start_workflows
    end
  end

  def start_workflows
    # Connect a client
    queue = Queue.new
    Temporalio::Bridge::Client.new($test_runtime, target_host: $test_server.target) { |val| queue.push(val) }
    client = queue.pop
    raise client if client.is_a? Temporalio::Bridge::Error

    # Start 5 workflows
    queue = Queue.new
    5.times do
      req = Temporalio::Api::WorkflowService::V1::StartWorkflowExecutionRequest.new(
        identity: 'some-identity',
        request_id: SecureRandom.uuid,
        namespace: 'default',
        workflow_type: Temporalio::Api::Common::V1::WorkflowType.new(name: 'MyWorkflow'),
        workflow_id: "my-workflow-#{SecureRandom.uuid}",
        task_queue: Temporalio::Api::TaskQueue::V1::TaskQueue.new(name: 'my-task-queue')
      )
      client.call_workflow_service(
        rpc: 'start_workflow_execution',
        req: Temporalio::Api::WorkflowService::V1::StartWorkflowExecutionRequest.encode(req),
        retry: true,
        metadata: nil,
        timeout_millis: 0
      ) { |val| queue.push(val) }
    end

    # Wait for 5
    results = 5.times.map do
      result = queue.pop
      if result.is_a? Temporalio::Bridge::Client::RpcFailure
        raise "Client call failed (code #{result.code}): #{result.message}"
      end

      Temporalio::Api::WorkflowService::V1::StartWorkflowExecutionResponse.decode(result)
    end
    puts 'Started workflows', results
  end
end
