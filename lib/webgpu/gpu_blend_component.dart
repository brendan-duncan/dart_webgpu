import '_map_util.dart';
import 'gpu_blend_factor.dart';
import 'gpu_blend_operation.dart';

class GPUBlendComponent {
  /// Defines the [GPUBlendOperation] used to calculate the values written to
  /// the target attachment components.
  final GPUBlendOperation operation;

  /// Defines the [GPUBlendFactor] operation to be performed on values from the
  /// fragment shader.
  final GPUBlendFactor srcFactor;

  /// Defines the [GPUBlendFactor] operation to be performed on values from the
  /// target attachment.
  final GPUBlendFactor dstFactor;

  const GPUBlendComponent(
      {this.operation = GPUBlendOperation.add,
      this.srcFactor = GPUBlendFactor.one,
      this.dstFactor = GPUBlendFactor.zero});

  factory GPUBlendComponent.fromMap(Map<String, Object> map) {
    final operation = getMapValue(map['operation'], GPUBlendOperation.add);
    final srcFactor = getMapValue(map['srcFactor'], GPUBlendFactor.one);
    final dstFactor = getMapValue(map['dstFactor'], GPUBlendFactor.zero);
    return GPUBlendComponent(
        operation: operation, srcFactor: srcFactor, dstFactor: dstFactor);
  }
}
