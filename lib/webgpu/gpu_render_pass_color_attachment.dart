import '_map_util.dart';
import 'gpu_load_op.dart';
import 'gpu_store_op.dart';
import 'gpu_texture_view.dart';

class GpuRenderPassColorAttachment {
  /// A TextureView describing the texture subresource that will be output to
  /// for this color attachment.
  final GpuTextureView view;

  /// A TextureView describing the texture subresource that will receive the
  /// resolved output for this color attachment if view is multisampled.
  final GpuTextureView? resolveTarget;

  /// Indicates the value to clear view to prior to executing the render pass.
  /// If not provided, defaults to {r: 0, g: 0, b: 0, a: 0}. Ignored if loadOp
  /// is not "clear". The components of clearValue are all double values.
  /// They are converted to a texel value of texture format matching the render
  /// attachment. If conversion fails, a validation error is generated.
  final List<num> clearValue;

  /// Indicates the load operation to perform on view prior to executing the
  /// render pass.
  final GpuLoadOp loadOp;

  /// The store operation to perform on view after executing the render pass.
  final StoreOp storeOp;

  const GpuRenderPassColorAttachment(
      {required this.view,
      this.resolveTarget,
      this.clearValue = const [0.0, 0.0, 0.0, 0.0],
      required this.loadOp,
      required this.storeOp});

  factory GpuRenderPassColorAttachment.fromMap(Map<String, Object> map) {
    final view = getMapValueRequired<GpuTextureView>(map['view']);
    final resolveTarget =
        getMapValue<GpuTextureView?>(map['resolveTarget'], null);
    final clearValue =
        getMapValue<List<num>>(map['clearValue'], [0.0, 0.0, 0.0, 0.0]);
    final loadOp = getMapValueRequired<GpuLoadOp>(map['loadOp']);
    final storeOp = getMapValueRequired<StoreOp>(map['storeOp']);

    return GpuRenderPassColorAttachment(
        view: view,
        loadOp: loadOp,
        storeOp: storeOp,
        resolveTarget: resolveTarget,
        clearValue: clearValue);
  }
}
