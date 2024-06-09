import '_map_util.dart';
import 'gpu_load_op.dart';
import 'gpu_store_op.dart';
import 'gpu_texture_view.dart';

class GPURenderPassColorAttachment {
  /// A TextureView describing the texture subresource that will be output to
  /// for this color attachment.
  final GPUTextureView view;

  final int depthSlice;

  /// A TextureView describing the texture subresource that will receive the
  /// resolved output for this color attachment if view is multisampled.
  final GPUTextureView? resolveTarget;

  /// Indicates the value to clear view to prior to executing the render pass.
  /// If not provided, defaults to {r: 0, g: 0, b: 0, a: 0}. Ignored if loadOp
  /// is not "clear". The components of clearValue are all double values.
  /// They are converted to a texel value of texture format matching the render
  /// attachment. If conversion fails, a validation error is generated.
  final List<num> clearValue;

  /// Indicates the load operation to perform on view prior to executing the
  /// render pass.
  final GPULoadOp loadOp;

  /// The store operation to perform on view after executing the render pass.
  final GPUStoreOp storeOp;

  const GPURenderPassColorAttachment(
      {required this.view,
      this.depthSlice = -1,
      this.resolveTarget,
      this.clearValue = const [0.0, 0.0, 0.0, 0.0],
      required this.loadOp,
      required this.storeOp});

  factory GPURenderPassColorAttachment.fromMap(Map<String, Object> map) {
    final view = mapValueRequired<GPUTextureView>(map['view']);
    final depthSlice = mapValue<int>(map['depthSlice'], -1);
    final resolveTarget =
        mapValueNullable<GPUTextureView>(map['resolveTarget']);
    final clearValue =
        mapValue<List<num>>(map['clearValue'], [0.0, 0.0, 0.0, 0.0]);
    final loadOp = mapValueRequired<GPULoadOp>(map['loadOp']);
    final storeOp = mapValueRequired<GPUStoreOp>(map['storeOp']);

    return GPURenderPassColorAttachment(
        view: view,
        depthSlice: depthSlice,
        loadOp: loadOp,
        storeOp: storeOp,
        resolveTarget: resolveTarget,
        clearValue: clearValue);
  }
}
