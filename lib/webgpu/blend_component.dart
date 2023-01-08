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
}
