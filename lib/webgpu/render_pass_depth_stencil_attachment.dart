import '_map_util.dart';
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

  factory RenderPassDepthStencilAttachment.fromMap(Map<String, Object> map) {
    final view = getMapValueRequired<TextureView>(map['view']);
    final depthClearValue = getMapValue<num>(map['depthClearValue'], 0);
    final depthLoadOp = getMapValue<LoadOp?>(map['depthLoadOp'], null);
    final depthStoreOp = getMapValue<StoreOp?>(map['depthStoreOp'], null);
    final depthReadOnly = getMapValue<bool>(map['depthReadOnly'], false);

    final stencilClearValue = getMapValue<int>(map['stencilClearValue'], 0);
    final stencilLoadOp = getMapValue<LoadOp?>(map['stencilLoadOp'], null);
    final stencilStoreOp = getMapValue<StoreOp?>(map['stencilStoreOp'], null);
    final stencilReadOnly = getMapValue<bool>(map['stencilReadOnly'], false);
    return RenderPassDepthStencilAttachment(
        view: view,
        depthClearValue: depthClearValue,
        depthLoadOp: depthLoadOp,
        depthStoreOp: depthStoreOp,
        depthReadOnly: depthReadOnly,
        stencilClearValue: stencilClearValue,
        stencilLoadOp: stencilLoadOp,
        stencilStoreOp: stencilStoreOp,
        stencilReadOnly: stencilReadOnly);
  }
}
