import '_map_util.dart';
import 'gpu_compare_function.dart';
import 'gpu_stencil_face_state.dart';
import 'gpu_texture_format.dart';

/// Describe how a GPURenderPipeline will affect a render pass’s
/// depthStencilAttachment.
class GPUDepthStencilState {
  /// The format of depthStencilAttachment this RenderPipeline will be
  /// compatible with.
  final GPUTextureFormat format;

  /// Indicates if this RenderPipeline can modify depthStencilAttachment depth
  /// values.
  final bool depthWriteEnabled;

  /// The comparison operation used to test fragment depths against
  /// depthStencilAttachment depth values.
  final GPUCompareFunction depthCompare;

  /// Defines how stencil comparisons and operations are performed for
  /// front-facing primitives.
  final GPUStencilFaceState stencilFront;

  /// Defines how stencil comparisons and operations are performed for
  /// back-facing primitives.
  final GPUStencilFaceState stencilBack;

  /// Bitmask controlling which depthStencilAttachment stencil value bits are
  /// read when performing stencil comparison tests.
  final int stencilReadMask;

  /// Bitmask controlling which depthStencilAttachment stencil value bits are
  /// written to when performing stencil operations.
  final int stencilWriteMask;

  /// Constant depth bias added to each fragment. See biased fragment depth for
  /// details.
  final int depthBias;

  /// Depth bias that scales with the fragment’s slope. See biased fragment
  /// depth for details.
  final num depthBiasSlopeScale;

  /// The maximum depth bias of a fragment. See biased fragment depth for
  /// details.
  final num depthBiasClamp;

  const GPUDepthStencilState(
      {required this.format,
      this.depthWriteEnabled = false,
      this.depthCompare = GPUCompareFunction.always,
      this.stencilFront = const GPUStencilFaceState(),
      this.stencilBack = const GPUStencilFaceState(),
      this.stencilReadMask = 0xffffffff,
      this.stencilWriteMask = 0xffffffff,
      this.depthBias = 0,
      this.depthBiasSlopeScale = 0,
      this.depthBiasClamp = 0});

  factory GPUDepthStencilState.fromMap(Map<String, Object> map) {
    final format = mapValueRequired<GPUTextureFormat>(map['format']);
    final depthWriteEnabled = mapValue(map['depthWriteEnabled'], false);
    final depthCompare =
        mapValue(map['depthCompare'], GPUCompareFunction.always);
    final stencilFront =
        mapObjectNullable<GPUStencilFaceState>(map['stencilFront']);
    final stencilBack =
        mapObjectNullable<GPUStencilFaceState>(map['stencilBack']);
    final stencilReadMask = mapValue(map['stencilReadMask'], 0xffffffff);
    final stencilWriteMask = mapValue(map['stencilWriteMask'], 0xffffffff);
    final depthBias = mapValue(map['depthBias'], 0);
    final depthBiasSlopeScale = mapValue(map['depthBiasSlopeScale'], 0);
    final depthBiasClamp = mapValue(map['depthBiasClamp'], 0);

    return GPUDepthStencilState(
        format: format,
        depthWriteEnabled: depthWriteEnabled,
        depthCompare: depthCompare,
        stencilFront: stencilFront ?? const GPUStencilFaceState(),
        stencilBack: stencilBack ?? const GPUStencilFaceState(),
        stencilReadMask: stencilReadMask,
        stencilWriteMask: stencilWriteMask,
        depthBias: depthBias,
        depthBiasSlopeScale: depthBiasSlopeScale,
        depthBiasClamp: depthBiasClamp);
  }
}
