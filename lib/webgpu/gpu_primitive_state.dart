import '_map_util.dart';
import 'gpu_cull_mode.dart';
import 'gpu_front_face.dart';
import 'gpu_index_format.dart';
import 'gpu_primitive_topology.dart';

class GPUPrimitiveState {
  final GPUPrimitiveTopology topology;
  final GPUIndexFormat stripIndexFormat;
  final GPUFrontFace frontFace;
  final GPUCullMode cullMode;
  final bool unclippedDepth;

  const GPUPrimitiveState(
      {this.topology = GPUPrimitiveTopology.triangleList,
      this.stripIndexFormat = GPUIndexFormat.undefined,
      this.frontFace = GPUFrontFace.ccw,
      this.cullMode = GPUCullMode.none,
      this.unclippedDepth = false});

  factory GPUPrimitiveState.fromMap(Map<String, Object> map) {
    final topology = mapValue<GPUPrimitiveTopology>(
        map['topology'], GPUPrimitiveTopology.triangleList);
    final stripIndexFormat = mapValue<GPUIndexFormat>(
        map['stripIndexFormat'], GPUIndexFormat.undefined);
    final frontFace =
        mapValue<GPUFrontFace>(map['frontFace'], GPUFrontFace.ccw);
    final cullMode =
        mapValue<GPUCullMode>(map['cullMode'], GPUCullMode.none);
    final unclippedDepth = mapValue<bool>(map['unclippedDepth'], false);

    return GPUPrimitiveState(
        topology: topology,
        stripIndexFormat: stripIndexFormat,
        frontFace: frontFace,
        cullMode: cullMode,
        unclippedDepth: unclippedDepth);
  }
}
