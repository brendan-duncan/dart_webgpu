import '_map_util.dart';
import 'blend_factor.dart';
import 'blend_operation.dart';

class BlendComponent {
  /// Defines the [BlendOperation] used to calculate the values written to the
  /// target attachment components.
  final BlendOperation operation;

  /// Defines the [BlendFactor] operation to be performed on values from the
  /// fragment shader.
  final BlendFactor srcFactor;

  /// Defines the [BlendFactor] operation to be performed on values from the
  /// target attachment.
  final BlendFactor dstFactor;

  const BlendComponent(
      {this.operation = BlendOperation.add,
      this.srcFactor = BlendFactor.one,
      this.dstFactor = BlendFactor.zero});

  factory BlendComponent.fromMap(Map<String, Object> map) {
    final operation = getMapValue(map['operation'], BlendOperation.add);
    final srcFactor = getMapValue(map['srcFactor'], BlendFactor.one);
    final dstFactor = getMapValue(map['dstFactor'], BlendFactor.zero);
    return BlendComponent(
        operation: operation, srcFactor: srcFactor, dstFactor: dstFactor);
  }
}
