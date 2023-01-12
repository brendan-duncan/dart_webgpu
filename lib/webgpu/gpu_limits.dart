import 'dart:ffi';

import '../ffi/ffi_webgpu.dart' as wgpu;

class GPULimits {
  int maxUniformBufferBindingSize = 0;
  int maxStorageBufferBindingSize = 0;
  int maxBufferSize = 0;
  int maxTextureDimension1D = 0;
  int maxTextureDimension2D = 0;
  int maxTextureDimension3D = 0;
  int maxTextureArrayLayers = 0;
  int maxBindGroups = 0;
  int maxBindingsPerBindGroup = 0;
  int maxDynamicUniformBuffersPerPipelineLayout = 0;
  int maxDynamicStorageBuffersPerPipelineLayout = 0;
  int maxSampledTexturesPerShaderStage = 0;
  int maxSamplersPerShaderStage = 0;
  int maxStorageBuffersPerShaderStage = 0;
  int maxStorageTexturesPerShaderStage = 0;
  int maxUniformBuffersPerShaderStage = 0;
  int minUniformBufferOffsetAlignment = 0;
  int minStorageBufferOffsetAlignment = 0;
  int maxVertexBuffers = 0;
  int maxVertexAttributes = 0;
  int maxVertexBufferArrayStride = 0;
  int maxInterStageShaderComponents = 0;
  int maxInterStageShaderVariables = 0;
  int maxColorAttachments = 0;
  int maxColorAttachmentBytesPerSample = 0;
  int maxComputeWorkgroupStorageSize = 0;
  int maxComputeInvocationsPerWorkgroup = 0;
  int maxComputeWorkgroupSizeX = 0;
  int maxComputeWorkgroupSizeY = 0;
  int maxComputeWorkgroupSizeZ = 0;

  GPULimits.fromWgpu(Pointer<wgpu.WGpuSupportedLimits> l) {
    setFrom(l);
  }

  void setFrom(Pointer<wgpu.WGpuSupportedLimits> l) {
    maxUniformBufferBindingSize = l.ref.maxUniformBufferBindingSize;
    maxStorageBufferBindingSize = l.ref.maxStorageBufferBindingSize;
    maxBufferSize = l.ref.maxBufferSize;
    maxTextureDimension1D = l.ref.maxTextureDimension1D;
    maxTextureDimension2D = l.ref.maxTextureDimension2D;
    maxTextureDimension3D = l.ref.maxTextureDimension3D;
    maxTextureArrayLayers = l.ref.maxTextureArrayLayers;
    maxBindGroups = l.ref.maxBindGroups;
    maxBindingsPerBindGroup = l.ref.maxBindingsPerBindGroup;
    maxDynamicUniformBuffersPerPipelineLayout =
        l.ref.maxDynamicUniformBuffersPerPipelineLayout;
    maxDynamicStorageBuffersPerPipelineLayout =
        l.ref.maxDynamicStorageBuffersPerPipelineLayout;
    maxSampledTexturesPerShaderStage = l.ref.maxSampledTexturesPerShaderStage;
    maxSamplersPerShaderStage = l.ref.maxSamplersPerShaderStage;
    maxStorageBuffersPerShaderStage = l.ref.maxStorageBuffersPerShaderStage;
    maxStorageTexturesPerShaderStage = l.ref.maxStorageTexturesPerShaderStage;
    maxUniformBuffersPerShaderStage = l.ref.maxUniformBuffersPerShaderStage;
    minUniformBufferOffsetAlignment = l.ref.minUniformBufferOffsetAlignment;
    minStorageBufferOffsetAlignment = l.ref.minStorageBufferOffsetAlignment;
    maxVertexBuffers = l.ref.maxVertexBuffers;
    maxVertexAttributes = l.ref.maxVertexAttributes;
    maxVertexBufferArrayStride = l.ref.maxVertexBufferArrayStride;
    maxInterStageShaderComponents = l.ref.maxInterStageShaderComponents;
    maxInterStageShaderVariables = l.ref.maxInterStageShaderVariables;
    maxColorAttachments = l.ref.maxColorAttachments;
    maxColorAttachmentBytesPerSample = l.ref.maxColorAttachmentBytesPerSample;
    maxComputeWorkgroupStorageSize = l.ref.maxComputeWorkgroupStorageSize;
    maxComputeInvocationsPerWorkgroup = l.ref.maxComputeInvocationsPerWorkgroup;
    maxComputeWorkgroupSizeX = l.ref.maxComputeWorkgroupSizeX;
    maxComputeWorkgroupSizeY = l.ref.maxComputeWorkgroupSizeY;
    maxComputeWorkgroupSizeZ = l.ref.maxComputeWorkgroupSizeZ;
  }

  void copyTo(wgpu.WGpuSupportedLimits l) {
    l
      ..maxUniformBufferBindingSize = maxUniformBufferBindingSize
      ..maxStorageBufferBindingSize = maxStorageBufferBindingSize
      ..maxBufferSize = maxBufferSize
      ..maxTextureDimension1D = maxTextureDimension1D
      ..maxTextureDimension2D = maxTextureDimension2D
      ..maxTextureDimension3D = maxTextureDimension3D
      ..maxTextureArrayLayers = maxTextureArrayLayers
      ..maxBindGroups = maxBindGroups
      ..maxBindingsPerBindGroup = maxBindingsPerBindGroup
      ..maxDynamicUniformBuffersPerPipelineLayout =
          maxDynamicUniformBuffersPerPipelineLayout
      ..maxDynamicStorageBuffersPerPipelineLayout =
          maxDynamicStorageBuffersPerPipelineLayout
      ..maxSampledTexturesPerShaderStage = maxSampledTexturesPerShaderStage
      ..maxSamplersPerShaderStage = maxSamplersPerShaderStage
      ..maxStorageBuffersPerShaderStage = maxStorageBuffersPerShaderStage
      ..maxStorageTexturesPerShaderStage = maxStorageTexturesPerShaderStage
      ..maxUniformBuffersPerShaderStage = maxUniformBuffersPerShaderStage
      ..minUniformBufferOffsetAlignment = minUniformBufferOffsetAlignment
      ..minStorageBufferOffsetAlignment = minStorageBufferOffsetAlignment
      ..maxVertexBuffers = maxVertexBuffers
      ..maxVertexAttributes = maxVertexAttributes
      ..maxVertexBufferArrayStride = maxVertexBufferArrayStride
      ..maxInterStageShaderComponents = maxInterStageShaderComponents
      ..maxInterStageShaderVariables = maxInterStageShaderVariables
      ..maxColorAttachments = maxColorAttachments
      ..maxColorAttachmentBytesPerSample = maxColorAttachmentBytesPerSample
      ..maxComputeWorkgroupStorageSize = maxComputeWorkgroupStorageSize
      ..maxComputeInvocationsPerWorkgroup = maxComputeInvocationsPerWorkgroup
      ..maxComputeWorkgroupSizeX = maxComputeWorkgroupSizeX
      ..maxComputeWorkgroupSizeY = maxComputeWorkgroupSizeY
      ..maxComputeWorkgroupSizeZ = maxComputeWorkgroupSizeZ;
  }

  @override
  String toString() =>
      '''maxUniformBufferBindingSize: $maxUniformBufferBindingSize
maxStorageBufferBindingSize: $maxStorageBufferBindingSize
maxBufferSize: $maxBufferSize
maxTextureDimension1D: $maxTextureDimension1D
maxTextureDimension2D: $maxTextureDimension2D
maxTextureDimension3D: $maxTextureDimension3D
maxTextureArrayLayers: $maxTextureArrayLayers
maxBindGroups: $maxBindGroups
maxBindingsPerBindGroup: $maxBindingsPerBindGroup
maxDynamicUniformBuffersPerPipelineLayout: $maxDynamicUniformBuffersPerPipelineLayout
maxDynamicStorageBuffersPerPipelineLayout: $maxDynamicStorageBuffersPerPipelineLayout
maxSampledTexturesPerShaderStage: $maxSampledTexturesPerShaderStage
maxSamplersPerShaderStage: $maxSamplersPerShaderStage
maxStorageBuffersPerShaderStage: $maxStorageBuffersPerShaderStage
maxStorageTexturesPerShaderStage: $maxStorageTexturesPerShaderStage
maxUniformBuffersPerShaderStage: $maxUniformBuffersPerShaderStage
minUniformBufferOffsetAlignment: $minUniformBufferOffsetAlignment
minStorageBufferOffsetAlignment: $minStorageBufferOffsetAlignment
maxVertexBuffers: $maxVertexBuffers
maxVertexAttributes: $maxVertexAttributes
maxVertexBufferArrayStride: $maxVertexBufferArrayStride
maxInterStageShaderComponents: $maxInterStageShaderComponents
maxInterStageShaderVariables: $maxInterStageShaderVariables
maxColorAttachments: $maxColorAttachments
maxColorAttachmentBytesPerSample: $maxColorAttachmentBytesPerSample
maxComputeWorkgroupStorageSize: $maxComputeWorkgroupStorageSize
maxComputeInvocationsPerWorkgroup: $maxComputeInvocationsPerWorkgroup
maxComputeWorkgroupSizeX: $maxComputeWorkgroupSizeX
maxComputeWorkgroupSizeY: $maxComputeWorkgroupSizeY
maxComputeWorkgroupSizeZ: $maxComputeWorkgroupSizeZ''';
}
