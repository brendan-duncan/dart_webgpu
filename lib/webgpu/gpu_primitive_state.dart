import '_map_util.dart';
import 'gpu_cull_mode.dart';
import 'gpu_front_face.dart';
import 'gpu_index_format.dart';
import 'gpu_primitive_topology.dart';

class GpuPrimitiveState {
  final GpuPrimitiveTopology topology;
  final GpuIndexFormat stripIndexFormat;
  final GpuFrontFace frontFace;
  final GpuCullMode cullMode;
  final bool unclippedDepth;

  const GpuPrimitiveState(
      {this.topology = GpuPrimitiveTopology.triangleList,
      this.stripIndexFormat = GpuIndexFormat.undefined,
      this.frontFace = GpuFrontFace.ccw,
      this.cullMode = GpuCullMode.none,
      this.unclippedDepth = false});

  factory GpuPrimitiveState.fromMap(Map<String, Object> map) {
    final topology = getMapValue<GpuPrimitiveTopology>(
        map['topology'], GpuPrimitiveTopology.triangleList);
    final stripIndexFormat = getMapValue<GpuIndexFormat>(
        map['stripIndexFormat'], GpuIndexFormat.undefined);
    final frontFace =
        getMapValue<GpuFrontFace>(map['frontFace'], GpuFrontFace.ccw);
    final cullMode =
        getMapValue<GpuCullMode>(map['cullMode'], GpuCullMode.none);
    final unclippedDepth = getMapValue<bool>(map['unclippedDepth'], false);

    return GpuPrimitiveState(
        topology: topology,
        stripIndexFormat: stripIndexFormat,
        frontFace: frontFace,
        cullMode: cullMode,
        unclippedDepth: unclippedDepth);
  }
}
