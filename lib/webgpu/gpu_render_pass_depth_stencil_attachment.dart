import '_map_util.dart';
import 'gpu_load_op.dart';
import 'gpu_store_op.dart';
import 'gpu_texture_view.dart';

class GpuRenderPassDepthStencilAttachment {
  final GpuTextureView view;

  final num depthClearValue;
  final GpuLoadOp? depthLoadOp;
  final StoreOp? depthStoreOp;
  final bool depthReadOnly;

  final int stencilClearValue;
  final GpuLoadOp? stencilLoadOp;
  final StoreOp? stencilStoreOp;
  final bool stencilReadOnly;

  const GpuRenderPassDepthStencilAttachment(
      {required this.view,
      this.depthClearValue = 0,
      this.depthLoadOp,
      this.depthStoreOp,
      this.depthReadOnly = false,
      this.stencilClearValue = 0,
      this.stencilLoadOp,
      this.stencilStoreOp,
      this.stencilReadOnly = false});

  factory GpuRenderPassDepthStencilAttachment.fromMap(Map<String, Object> map) {
    final view = getMapValueRequired<GpuTextureView>(map['view']);
    final depthClearValue = getMapValue<num>(map['depthClearValue'], 0);
    final depthLoadOp = getMapValue<GpuLoadOp?>(map['depthLoadOp'], null);
    final depthStoreOp = getMapValue<StoreOp?>(map['depthStoreOp'], null);
    final depthReadOnly = getMapValue<bool>(map['depthReadOnly'], false);

    final stencilClearValue = getMapValue<int>(map['stencilClearValue'], 0);
    final stencilLoadOp = getMapValue<GpuLoadOp?>(map['stencilLoadOp'], null);
    final stencilStoreOp = getMapValue<StoreOp?>(map['stencilStoreOp'], null);
    final stencilReadOnly = getMapValue<bool>(map['stencilReadOnly'], false);
    return GpuRenderPassDepthStencilAttachment(
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
