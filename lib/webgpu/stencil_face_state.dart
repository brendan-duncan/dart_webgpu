import 'compare_function.dart';
import 'stencil_operation.dart';

class StencilFaceState {
  final CompareFunction compare;
  final StencilOperation failOp;
  final StencilOperation depthFailOp;
  final StencilOperation passOp;

  const StencilFaceState(
      {this.compare = CompareFunction.always,
      this.failOp = StencilOperation.keep,
      this.depthFailOp = StencilOperation.keep,
      this.passOp = StencilOperation.keep});
}
