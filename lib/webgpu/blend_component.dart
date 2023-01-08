import 'blend_factor.dart';
import 'blend_operation.dart';

class BlendComponent {
  final BlendOperation operation;
  final BlendFactor srcFactor;
  final BlendFactor dstFactor;

  const BlendComponent(
      {this.operation = BlendOperation.add,
      this.srcFactor = BlendFactor.one,
      this.dstFactor = BlendFactor.zero});
}
