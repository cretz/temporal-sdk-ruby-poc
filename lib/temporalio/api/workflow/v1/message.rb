# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: temporal/api/workflow/v1/message.proto

require 'google/protobuf'

require 'google/protobuf/duration_pb'
require 'google/protobuf/timestamp_pb'
require 'temporalio/api/enums/v1/workflow'
require 'temporalio/api/common/v1/message'
require 'temporalio/api/failure/v1/message'
require 'temporalio/api/taskqueue/v1/message'


descriptor_data = "\n&temporal/api/workflow/v1/message.proto\x12\x18temporal.api.workflow.v1\x1a\x1egoogle/protobuf/duration.proto\x1a\x1fgoogle/protobuf/timestamp.proto\x1a$temporal/api/enums/v1/workflow.proto\x1a$temporal/api/common/v1/message.proto\x1a%temporal/api/failure/v1/message.proto\x1a\'temporal/api/taskqueue/v1/message.proto\"\xb0\x06\n\x15WorkflowExecutionInfo\x12<\n\texecution\x18\x01 \x01(\x0b\x32).temporal.api.common.v1.WorkflowExecution\x12\x32\n\x04type\x18\x02 \x01(\x0b\x32$.temporal.api.common.v1.WorkflowType\x12.\n\nstart_time\x18\x03 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12.\n\nclose_time\x18\x04 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12>\n\x06status\x18\x05 \x01(\x0e\x32..temporal.api.enums.v1.WorkflowExecutionStatus\x12\x16\n\x0ehistory_length\x18\x06 \x01(\x03\x12\x1b\n\x13parent_namespace_id\x18\x07 \x01(\t\x12\x43\n\x10parent_execution\x18\x08 \x01(\x0b\x32).temporal.api.common.v1.WorkflowExecution\x12\x32\n\x0e\x65xecution_time\x18\t \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12*\n\x04memo\x18\n \x01(\x0b\x32\x1c.temporal.api.common.v1.Memo\x12\x43\n\x11search_attributes\x18\x0b \x01(\x0b\x32(.temporal.api.common.v1.SearchAttributes\x12@\n\x11\x61uto_reset_points\x18\x0c \x01(\x0b\x32%.temporal.api.workflow.v1.ResetPoints\x12\x12\n\ntask_queue\x18\r \x01(\t\x12\x1e\n\x16state_transition_count\x18\x0e \x01(\x03\x12\x1a\n\x12history_size_bytes\x18\x0f \x01(\x03\x12T\n most_recent_worker_version_stamp\x18\x10 \x01(\x0b\x32*.temporal.api.common.v1.WorkerVersionStamp\"\x8d\x02\n\x17WorkflowExecutionConfig\x12\x38\n\ntask_queue\x18\x01 \x01(\x0b\x32$.temporal.api.taskqueue.v1.TaskQueue\x12=\n\x1aworkflow_execution_timeout\x18\x02 \x01(\x0b\x32\x19.google.protobuf.Duration\x12\x37\n\x14workflow_run_timeout\x18\x03 \x01(\x0b\x32\x19.google.protobuf.Duration\x12@\n\x1d\x64\x65\x66\x61ult_workflow_task_timeout\x18\x04 \x01(\x0b\x32\x19.google.protobuf.Duration\"\xba\x04\n\x13PendingActivityInfo\x12\x13\n\x0b\x61\x63tivity_id\x18\x01 \x01(\t\x12;\n\ractivity_type\x18\x02 \x01(\x0b\x32$.temporal.api.common.v1.ActivityType\x12:\n\x05state\x18\x03 \x01(\x0e\x32+.temporal.api.enums.v1.PendingActivityState\x12;\n\x11heartbeat_details\x18\x04 \x01(\x0b\x32 .temporal.api.common.v1.Payloads\x12\x37\n\x13last_heartbeat_time\x18\x05 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x35\n\x11last_started_time\x18\x06 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x0f\n\x07\x61ttempt\x18\x07 \x01(\x05\x12\x18\n\x10maximum_attempts\x18\x08 \x01(\x05\x12\x32\n\x0escheduled_time\x18\t \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x33\n\x0f\x65xpiration_time\x18\n \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x36\n\x0clast_failure\x18\x0b \x01(\x0b\x32 .temporal.api.failure.v1.Failure\x12\x1c\n\x14last_worker_identity\x18\x0c \x01(\t\"\xb9\x01\n\x19PendingChildExecutionInfo\x12\x13\n\x0bworkflow_id\x18\x01 \x01(\t\x12\x0e\n\x06run_id\x18\x02 \x01(\t\x12\x1a\n\x12workflow_type_name\x18\x03 \x01(\t\x12\x14\n\x0cinitiated_id\x18\x04 \x01(\x03\x12\x45\n\x13parent_close_policy\x18\x05 \x01(\x0e\x32(.temporal.api.enums.v1.ParentClosePolicy\"\x8d\x02\n\x17PendingWorkflowTaskInfo\x12>\n\x05state\x18\x01 \x01(\x0e\x32/.temporal.api.enums.v1.PendingWorkflowTaskState\x12\x32\n\x0escheduled_time\x18\x02 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12;\n\x17original_scheduled_time\x18\x03 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x30\n\x0cstarted_time\x18\x04 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x0f\n\x07\x61ttempt\x18\x05 \x01(\x05\"G\n\x0bResetPoints\x12\x38\n\x06points\x18\x01 \x03(\x0b\x32(.temporal.api.workflow.v1.ResetPointInfo\"\xeb\x01\n\x0eResetPointInfo\x12\x10\n\x08\x62uild_id\x18\x07 \x01(\t\x12\x17\n\x0f\x62inary_checksum\x18\x01 \x01(\t\x12\x0e\n\x06run_id\x18\x02 \x01(\t\x12(\n first_workflow_task_completed_id\x18\x03 \x01(\x03\x12/\n\x0b\x63reate_time\x18\x04 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12/\n\x0b\x65xpire_time\x18\x05 \x01(\x0b\x32\x1a.google.protobuf.Timestamp\x12\x12\n\nresettable\x18\x06 \x01(\x08\"\xcc\x05\n\x18NewWorkflowExecutionInfo\x12\x13\n\x0bworkflow_id\x18\x01 \x01(\t\x12;\n\rworkflow_type\x18\x02 \x01(\x0b\x32$.temporal.api.common.v1.WorkflowType\x12\x38\n\ntask_queue\x18\x03 \x01(\x0b\x32$.temporal.api.taskqueue.v1.TaskQueue\x12/\n\x05input\x18\x04 \x01(\x0b\x32 .temporal.api.common.v1.Payloads\x12=\n\x1aworkflow_execution_timeout\x18\x05 \x01(\x0b\x32\x19.google.protobuf.Duration\x12\x37\n\x14workflow_run_timeout\x18\x06 \x01(\x0b\x32\x19.google.protobuf.Duration\x12\x38\n\x15workflow_task_timeout\x18\x07 \x01(\x0b\x32\x19.google.protobuf.Duration\x12N\n\x18workflow_id_reuse_policy\x18\x08 \x01(\x0e\x32,.temporal.api.enums.v1.WorkflowIdReusePolicy\x12\x39\n\x0cretry_policy\x18\t \x01(\x0b\x32#.temporal.api.common.v1.RetryPolicy\x12\x15\n\rcron_schedule\x18\n \x01(\t\x12*\n\x04memo\x18\x0b \x01(\x0b\x32\x1c.temporal.api.common.v1.Memo\x12\x43\n\x11search_attributes\x18\x0c \x01(\x0b\x32(.temporal.api.common.v1.SearchAttributes\x12.\n\x06header\x18\r \x01(\x0b\x32\x1e.temporal.api.common.v1.HeaderB\x93\x01\n\x1bio.temporal.api.workflow.v1B\x0cMessageProtoP\x01Z\'go.temporal.io/api/workflow/v1;workflow\xaa\x02\x1aTemporalio.Api.Workflow.V1\xea\x02\x1dTemporalio::Api::Workflow::V1b\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Temporalio
  module Api
    module Workflow
      module V1
        WorkflowExecutionInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.WorkflowExecutionInfo").msgclass
        WorkflowExecutionConfig = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.WorkflowExecutionConfig").msgclass
        PendingActivityInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.PendingActivityInfo").msgclass
        PendingChildExecutionInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.PendingChildExecutionInfo").msgclass
        PendingWorkflowTaskInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.PendingWorkflowTaskInfo").msgclass
        ResetPoints = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.ResetPoints").msgclass
        ResetPointInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.ResetPointInfo").msgclass
        NewWorkflowExecutionInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.workflow.v1.NewWorkflowExecutionInfo").msgclass
      end
    end
  end
end