import 'compare_function.dart';
import 'stencil_face_state.dart';
import 'texture_format.dart';

class DepthStencilState {
  final TextureFormat format;
  final bool depthWriteEnabled;
  final CompareFunction depthCompare;
  final StencilFaceState stencilFront;
  final StencilFaceState stencilBack;
  final int stencilReadMask;
  final int stencilWriteMask;
  final int depthBias;
  final num depthBiasSlopeScale;
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
}
