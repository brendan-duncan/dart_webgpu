import '_map_util.dart';
import 'gpu_compare_function.dart';
import 'gpu_stencil_operation.dart';

class GpuStencilFaceState {
  final GpuCompareFunction compare;
  final GpuStencilOperation failOp;
  final GpuStencilOperation depthFailOp;
  final GpuStencilOperation passOp;

  const GpuStencilFaceState(
      {this.compare = GpuCompareFunction.always,
      this.failOp = GpuStencilOperation.keep,
      this.depthFailOp = GpuStencilOperation.keep,
      this.passOp = GpuStencilOperation.keep});

  factory GpuStencilFaceState.fromMap(Map<String, Object> map) {
    final compare = getMapValue<GpuCompareFunction>(
        map['compare'], GpuCompareFunction.always);
    final failOp = getMapValue(map['failOp'], GpuStencilOperation.keep);
    final depthFailOp =
        getMapValue(map['depthFailOp'], GpuStencilOperation.keep);
    final passOp = getMapValue(map['passOp'], GpuStencilOperation.keep);
    return GpuStencilFaceState(
        compare: compare,
        failOp: failOp,
        depthFailOp: depthFailOp,
        passOp: passOp);
  }
}
