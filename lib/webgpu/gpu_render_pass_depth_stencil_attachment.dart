import '_map_util.dart';
import 'gpu_load_op.dart';
import 'gpu_store_op.dart';
import 'gpu_texture_view.dart';

class GPURenderPassDepthStencilAttachment {
  final GPUTextureView view;

  final num depthClearValue;
  final GPULoadOp? depthLoadOp;
  final GPUStoreOp? depthStoreOp;
  final bool depthReadOnly;

  final int stencilClearValue;
  final GPULoadOp? stencilLoadOp;
  final GPUStoreOp? stencilStoreOp;
  final bool stencilReadOnly;

  const GPURenderPassDepthStencilAttachment(
      {required this.view,
      this.depthClearValue = 0,
      this.depthLoadOp,
      this.depthStoreOp,
      this.depthReadOnly = false,
      this.stencilClearValue = 0,
      this.stencilLoadOp,
      this.stencilStoreOp,
      this.stencilReadOnly = false});

  factory GPURenderPassDepthStencilAttachment.fromMap(Map<String, Object> map) {
    final view = getMapValueRequired<GPUTextureView>(map['view']);
    final depthClearValue = getMapValue<num>(map['depthClearValue'], 0);
    final depthLoadOp = getMapValue<GPULoadOp?>(map['depthLoadOp'], null);
    final depthStoreOp = getMapValue<GPUStoreOp?>(map['depthStoreOp'], null);
    final depthReadOnly = getMapValue<bool>(map['depthReadOnly'], false);

    final stencilClearValue = getMapValue<int>(map['stencilClearValue'], 0);
    final stencilLoadOp = getMapValue<GPULoadOp?>(map['stencilLoadOp'], null);
    final stencilStoreOp =
        getMapValue<GPUStoreOp?>(map['stencilStoreOp'], null);
    final stencilReadOnly = getMapValue<bool>(map['stencilReadOnly'], false);
    return GPURenderPassDepthStencilAttachment(
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
