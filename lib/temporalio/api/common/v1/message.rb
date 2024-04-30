# frozen_string_literal: true
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: temporal/api/common/v1/message.proto

require 'google/protobuf'

require 'google/protobuf/duration_pb'
require 'google/protobuf/empty_pb'
require 'temporalio/api/enums/v1/common'
require 'temporalio/api/enums/v1/reset'


descriptor_data = "\n$temporal/api/common/v1/message.proto\x12\x16temporal.api.common.v1\x1a\x1egoogle/protobuf/duration.proto\x1a\x1bgoogle/protobuf/empty.proto\x1a\"temporal/api/enums/v1/common.proto\x1a!temporal/api/enums/v1/reset.proto\"T\n\x08\x44\x61taBlob\x12:\n\rencoding_type\x18\x01 \x01(\x0e\x32#.temporal.api.enums.v1.EncodingType\x12\x0c\n\x04\x64\x61ta\x18\x02 \x01(\x0c\"=\n\x08Payloads\x12\x31\n\x08payloads\x18\x01 \x03(\x0b\x32\x1f.temporal.api.common.v1.Payload\"\x89\x01\n\x07Payload\x12?\n\x08metadata\x18\x01 \x03(\x0b\x32-.temporal.api.common.v1.Payload.MetadataEntry\x12\x0c\n\x04\x64\x61ta\x18\x02 \x01(\x0c\x1a/\n\rMetadataEntry\x12\x0b\n\x03key\x18\x01 \x01(\t\x12\r\n\x05value\x18\x02 \x01(\x0c:\x02\x38\x01\"\xbe\x01\n\x10SearchAttributes\x12S\n\x0eindexed_fields\x18\x01 \x03(\x0b\x32;.temporal.api.common.v1.SearchAttributes.IndexedFieldsEntry\x1aU\n\x12IndexedFieldsEntry\x12\x0b\n\x03key\x18\x01 \x01(\t\x12.\n\x05value\x18\x02 \x01(\x0b\x32\x1f.temporal.api.common.v1.Payload:\x02\x38\x01\"\x90\x01\n\x04Memo\x12\x38\n\x06\x66ields\x18\x01 \x03(\x0b\x32(.temporal.api.common.v1.Memo.FieldsEntry\x1aN\n\x0b\x46ieldsEntry\x12\x0b\n\x03key\x18\x01 \x01(\t\x12.\n\x05value\x18\x02 \x01(\x0b\x32\x1f.temporal.api.common.v1.Payload:\x02\x38\x01\"\x94\x01\n\x06Header\x12:\n\x06\x66ields\x18\x01 \x03(\x0b\x32*.temporal.api.common.v1.Header.FieldsEntry\x1aN\n\x0b\x46ieldsEntry\x12\x0b\n\x03key\x18\x01 \x01(\t\x12.\n\x05value\x18\x02 \x01(\x0b\x32\x1f.temporal.api.common.v1.Payload:\x02\x38\x01\"8\n\x11WorkflowExecution\x12\x13\n\x0bworkflow_id\x18\x01 \x01(\t\x12\x0e\n\x06run_id\x18\x02 \x01(\t\"\x1c\n\x0cWorkflowType\x12\x0c\n\x04name\x18\x01 \x01(\t\"\x1c\n\x0c\x41\x63tivityType\x12\x0c\n\x04name\x18\x01 \x01(\t\"\xd1\x01\n\x0bRetryPolicy\x12\x33\n\x10initial_interval\x18\x01 \x01(\x0b\x32\x19.google.protobuf.Duration\x12\x1b\n\x13\x62\x61\x63koff_coefficient\x18\x02 \x01(\x01\x12\x33\n\x10maximum_interval\x18\x03 \x01(\x0b\x32\x19.google.protobuf.Duration\x12\x18\n\x10maximum_attempts\x18\x04 \x01(\x05\x12!\n\x19non_retryable_error_types\x18\x05 \x03(\t\"F\n\x10MeteringMetadata\x12\x32\n*nonfirst_local_activity_execution_attempts\x18\r \x01(\r\"Q\n\x12WorkerVersionStamp\x12\x10\n\x08\x62uild_id\x18\x01 \x01(\t\x12\x11\n\tbundle_id\x18\x02 \x01(\t\x12\x16\n\x0euse_versioning\x18\x03 \x01(\x08\"E\n\x19WorkerVersionCapabilities\x12\x10\n\x08\x62uild_id\x18\x01 \x01(\t\x12\x16\n\x0euse_versioning\x18\x02 \x01(\x08\"\x94\x02\n\x0cResetOptions\x12\x35\n\x13\x66irst_workflow_task\x18\x01 \x01(\x0b\x32\x16.google.protobuf.EmptyH\x00\x12\x34\n\x12last_workflow_task\x18\x02 \x01(\x0b\x32\x16.google.protobuf.EmptyH\x00\x12\x1a\n\x10workflow_task_id\x18\x03 \x01(\x03H\x00\x12\x12\n\x08\x62uild_id\x18\x04 \x01(\tH\x00\x12\x43\n\x12reset_reapply_type\x18\n \x01(\x0e\x32\'.temporal.api.enums.v1.ResetReapplyType\x12\x18\n\x10\x63urrent_run_only\x18\x0b \x01(\x08\x42\x08\n\x06targetB\x89\x01\n\x19io.temporal.api.common.v1B\x0cMessageProtoP\x01Z#go.temporal.io/api/common/v1;common\xaa\x02\x18Temporalio.Api.Common.V1\xea\x02\x1bTemporalio::Api::Common::V1b\x06proto3"

pool = Google::Protobuf::DescriptorPool.generated_pool
pool.add_serialized_file(descriptor_data)

module Temporalio
  module Api
    module Common
      module V1
        DataBlob = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.DataBlob").msgclass
        Payloads = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.Payloads").msgclass
        Payload = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.Payload").msgclass
        SearchAttributes = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.SearchAttributes").msgclass
        Memo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.Memo").msgclass
        Header = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.Header").msgclass
        WorkflowExecution = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.WorkflowExecution").msgclass
        WorkflowType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.WorkflowType").msgclass
        ActivityType = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.ActivityType").msgclass
        RetryPolicy = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.RetryPolicy").msgclass
        MeteringMetadata = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.MeteringMetadata").msgclass
        WorkerVersionStamp = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.WorkerVersionStamp").msgclass
        WorkerVersionCapabilities = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.WorkerVersionCapabilities").msgclass
        ResetOptions = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("temporal.api.common.v1.ResetOptions").msgclass
      end
    end
  end
end