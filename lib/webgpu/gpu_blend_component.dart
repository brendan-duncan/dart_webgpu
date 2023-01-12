import '_map_util.dart';
import 'gpu_blend_factor.dart';
import 'gpu_blend_operation.dart';

class GpuBlendComponent {
  /// Defines the [GpuBlendOperation] used to calculate the values written to the
  /// target attachment components.
  final GpuBlendOperation operation;

  /// Defines the [GpuBlendFactor] operation to be performed on values from the
  /// fragment shader.
  final GpuBlendFactor srcFactor;

  /// Defines the [GpuBlendFactor] operation to be performed on values from the
  /// target attachment.
  final GpuBlendFactor dstFactor;

  const GpuBlendComponent(
      {this.operation = GpuBlendOperation.add,
      this.srcFactor = GpuBlendFactor.one,
      this.dstFactor = GpuBlendFactor.zero});

  factory GpuBlendComponent.fromMap(Map<String, Object> map) {
    final operation = getMapValue(map['operation'], GpuBlendOperation.add);
    final srcFactor = getMapValue(map['srcFactor'], GpuBlendFactor.one);
    final dstFactor = getMapValue(map['dstFactor'], GpuBlendFactor.zero);
    return GpuBlendComponent(
        operation: operation, srcFactor: srcFactor, dstFactor: dstFactor);
  }
}
