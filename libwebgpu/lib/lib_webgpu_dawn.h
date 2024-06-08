#pragma once

enum _WgpuObjectType {
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

// lib_webgpu.js tracks derived objects and deletes them when the parent object is deleted.
// This may potentially cause bad pointers because WGpuObjectBase is a pointer to a _WGpuObject,
// and if the app still has a pointer to a derived object after it deletes the parent object,
// it would be a bad pointer. The app should make sure to delete derived objects before a parent
// object, such as deleting all texture_view's before deleting the texture.

struct _WGpuObject {
  _WgpuObjectType type; // C/Dawn doesn't have the RTTI that JS has.
  void* dawnObject;
};
