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
    final view = mapValueRequired<GPUTextureView>(map['view']);
    final depthClearValue = mapValue<num>(map['depthClearValue'], 0);
    final depthLoadOp = mapValueNullable<GPULoadOp>(map['depthLoadOp']);
    final depthStoreOp = mapValueNullable<GPUStoreOp>(map['depthStoreOp']);
    final depthReadOnly = mapValue<bool>(map['depthReadOnly'], false);

    final stencilClearValue = mapValue<int>(map['stencilClearValue'], 0);
    final stencilLoadOp = mapValueNullable<GPULoadOp>(map['stencilLoadOp']);
    final stencilStoreOp =
        mapValueNullable<GPUStoreOp>(map['stencilStoreOp']);
    final stencilReadOnly = mapValue<bool>(map['stencilReadOnly'], false);
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
