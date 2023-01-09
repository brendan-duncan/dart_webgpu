import 'load_op.dart';
import 'store_op.dart';
import 'texture_view.dart';

class RenderPassDepthStencilAttachment {
  final TextureView view;

  final num depthClearValue;
  final LoadOp? depthLoadOp;
  final StoreOp? depthStoreOp;
  final bool depthReadOnly;

  final int stencilClearValue;
  final LoadOp? stencilLoadOp;
  final StoreOp? stencilStoreOp;
  final bool stencilReadOnly;

  const RenderPassDepthStencilAttachment(
      {required this.view,
      this.depthClearValue = 0,
      this.depthLoadOp,
      this.depthStoreOp,
      this.depthReadOnly = false,
      this.stencilClearValue = 0,
      this.stencilLoadOp,
      this.stencilStoreOp,
      this.stencilReadOnly = false});
}
