import '_map_util.dart';
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

  factory StencilFaceState.fromMap(Map<String, Object> map) {
    final compare =
        getMapValue<CompareFunction>(map['compare'], CompareFunction.always);
    final failOp = getMapValue(map['failOp'], StencilOperation.keep);
    final depthFailOp = getMapValue(map['depthFailOp'], StencilOperation.keep);
    final passOp = getMapValue(map['passOp'], StencilOperation.keep);
    return StencilFaceState(
        compare: compare,
        failOp: failOp,
        depthFailOp: depthFailOp,
        passOp: passOp);
  }
}
