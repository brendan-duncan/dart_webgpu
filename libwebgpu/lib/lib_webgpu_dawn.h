#pragma once

enum WgpuObjectType {
  kWebGPUInvalidObject = 0,
  kWebGPUAdapter,
  kWebGPUDevice,
  kWebGPUBindGroupLayout,
  kWebGPUBuffer,
  kWebGPUTexture,
  kWebGPUTextureView,
  kWebGPUExternalTexture,
  kWebGPUSampler,
  kWebGPUBindGroup,
  kWebGPUPipelineLayout,
  kWebGPUShaderModule,
  kWebGPUComputePipeline,
  kWebGPURenderPipeline,
  kWebGPUCommandBuffer,
  kWebGPUCommandEncoder,
  kWebGPUComputePassEncoder,
  kWebGPURenderPassEncoder,
  kWebGPURenderBundle,
  kWebGPURenderBundleEncoder,
  kWebGPUQueue,
  kWebGPUQuerySet,
  kWebGPUCanvasContext
};

struct WGpuDawnObject {
  enum WgpuObjectType type; // C/Dawn doesn't have the RTTI that JS has.
  void* dawnObject;
};
