import '_map_util.dart';
import 'compare_function.dart';
import 'stencil_face_state.dart';
import 'texture_format.dart';

/// Describe how a GPURenderPipeline will affect a render pass’s
/// depthStencilAttachment.
class DepthStencilState {
  /// The format of depthStencilAttachment this RenderPipeline will be
  /// compatible with.
  final TextureFormat format;

  /// Indicates if this RenderPipeline can modify depthStencilAttachment depth
  /// values.
  final bool depthWriteEnabled;

  /// The comparison operation used to test fragment depths against
  /// depthStencilAttachment depth values.
  final CompareFunction depthCompare;

  /// Defines how stencil comparisons and operations are performed for
  /// front-facing primitives.
  final StencilFaceState stencilFront;

  /// Defines how stencil comparisons and operations are performed for
  /// back-facing primitives.
  final StencilFaceState stencilBack;

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

  const DepthStencilState(
      {required this.format,
      this.depthWriteEnabled = false,
      this.depthCompare = CompareFunction.always,
      this.stencilFront = const StencilFaceState(),
      this.stencilBack = const StencilFaceState(),
      this.stencilReadMask = 0xffffffff,
      this.stencilWriteMask = 0xffffffff,
      this.depthBias = 0,
      this.depthBiasSlopeScale = 0,
      this.depthBiasClamp = 0});

  factory DepthStencilState.fromMap(Map<String, Object> map) {
    final format = getMapValueRequired<TextureFormat>(map['format']);
    final depthWriteEnabled = getMapValue(map['depthWriteEnabled'], false);
    final depthCompare =
        getMapValue(map['depthCompare'], CompareFunction.always);
    final stencilFront =
        getMapObjectNullable<StencilFaceState>(map['stencilFront']);
    final stencilBack =
        getMapObjectNullable<StencilFaceState>(map['stencilBack']);
    final stencilReadMask = getMapValue(map['stencilReadMask'], 0xffffffff);
    final stencilWriteMask = getMapValue(map['stencilWriteMask'], 0xffffffff);
    final depthBias = getMapValue(map['depthBias'], 0);
    final depthBiasSlopeScale = getMapValue(map['depthBiasSlopeScale'], 0);
    final depthBiasClamp = getMapValue(map['depthBiasClamp'], 0);

    return DepthStencilState(
        format: format,
        depthWriteEnabled: depthWriteEnabled,
        depthCompare: depthCompare,
        stencilFront: stencilFront ?? const StencilFaceState(),
        stencilBack: stencilBack ?? const StencilFaceState(),
        stencilReadMask: stencilReadMask,
        stencilWriteMask: stencilWriteMask,
        depthBias: depthBias,
        depthBiasSlopeScale: depthBiasSlopeScale,
        depthBiasClamp: depthBiasClamp);
  }
}
