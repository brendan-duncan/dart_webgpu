import '_map_util.dart';
import 'gpu_compare_function.dart';
import 'gpu_stencil_operation.dart';

class GPUStencilFaceState {
  final GPUCompareFunction compare;
  final GPUStencilOperation failOp;
  final GPUStencilOperation depthFailOp;
  final GPUStencilOperation passOp;

  const GPUStencilFaceState(
      {this.compare = GPUCompareFunction.always,
      this.failOp = GPUStencilOperation.keep,
      this.depthFailOp = GPUStencilOperation.keep,
      this.passOp = GPUStencilOperation.keep});

  factory GPUStencilFaceState.fromMap(Map<String, Object> map) {
    final compare = mapValue<GPUCompareFunction>(
        map['compare'], GPUCompareFunction.always);
    final failOp = mapValue(map['failOp'], GPUStencilOperation.keep);
    final depthFailOp =
        mapValue(map['depthFailOp'], GPUStencilOperation.keep);
    final passOp = mapValue(map['passOp'], GPUStencilOperation.keep);
    return GPUStencilFaceState(
        compare: compare,
        failOp: failOp,
        depthFailOp: depthFailOp,
        passOp: passOp);
  }
}
