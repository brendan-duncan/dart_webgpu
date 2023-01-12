import '_map_util.dart';
import 'gpu_compare_function.dart';
import 'gpu_stencil_face_state.dart';
import 'gpu_texture_format.dart';

/// Describe how a GPURenderPipeline will affect a render pass’s
/// depthStencilAttachment.
class GpuDepthStencilState {
  /// The format of depthStencilAttachment this RenderPipeline will be
  /// compatible with.
  final GpuTextureFormat format;

  /// Indicates if this RenderPipeline can modify depthStencilAttachment depth
  /// values.
  final bool depthWriteEnabled;

  /// The comparison operation used to test fragment depths against
  /// depthStencilAttachment depth values.
  final GpuCompareFunction depthCompare;

  /// Defines how stencil comparisons and operations are performed for
  /// front-facing primitives.
  final GpuStencilFaceState stencilFront;

  /// Defines how stencil comparisons and operations are performed for
  /// back-facing primitives.
  final GpuStencilFaceState stencilBack;

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

  const GpuDepthStencilState(
      {required this.format,
      this.depthWriteEnabled = false,
      this.depthCompare = GpuCompareFunction.always,
      this.stencilFront = const GpuStencilFaceState(),
      this.stencilBack = const GpuStencilFaceState(),
      this.stencilReadMask = 0xffffffff,
      this.stencilWriteMask = 0xffffffff,
      this.depthBias = 0,
      this.depthBiasSlopeScale = 0,
      this.depthBiasClamp = 0});

  factory GpuDepthStencilState.fromMap(Map<String, Object> map) {
    final format = getMapValueRequired<GpuTextureFormat>(map['format']);
    final depthWriteEnabled = getMapValue(map['depthWriteEnabled'], false);
    final depthCompare =
        getMapValue(map['depthCompare'], GpuCompareFunction.always);
    final stencilFront =
        getMapObjectNullable<GpuStencilFaceState>(map['stencilFront']);
    final stencilBack =
        getMapObjectNullable<GpuStencilFaceState>(map['stencilBack']);
    final stencilReadMask = getMapValue(map['stencilReadMask'], 0xffffffff);
    final stencilWriteMask = getMapValue(map['stencilWriteMask'], 0xffffffff);
    final depthBias = getMapValue(map['depthBias'], 0);
    final depthBiasSlopeScale = getMapValue(map['depthBiasSlopeScale'], 0);
    final depthBiasClamp = getMapValue(map['depthBiasClamp'], 0);

    return GpuDepthStencilState(
        format: format,
        depthWriteEnabled: depthWriteEnabled,
        depthCompare: depthCompare,
        stencilFront: stencilFront ?? const GpuStencilFaceState(),
        stencilBack: stencilBack ?? const GpuStencilFaceState(),
        stencilReadMask: stencilReadMask,
        stencilWriteMask: stencilWriteMask,
        depthBias: depthBias,
        depthBiasSlopeScale: depthBiasSlopeScale,
        depthBiasClamp: depthBiasClamp);
  }
}
