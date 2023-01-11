import '_map_util.dart';
import 'cull_mode.dart';
import 'front_face.dart';
import 'index_format.dart';
import 'primitive_topology.dart';

class PrimitiveState {
  final PrimitiveTopology topology;
  final IndexFormat stripIndexFormat;
  final FrontFace frontFace;
  final CullMode cullMode;
  final bool unclippedDepth;

  const PrimitiveState(
      {this.topology = PrimitiveTopology.triangleList,
      this.stripIndexFormat = IndexFormat.undefined,
      this.frontFace = FrontFace.ccw,
      this.cullMode = CullMode.none,
      this.unclippedDepth = false});

  factory PrimitiveState.fromMap(Map<String, Object> map) {
    final topology =
        getMapValue(map, 'topology', PrimitiveTopology.triangleList);
    final stripIndexFormat =
        getMapValue(map, 'stripIndexFormat', IndexFormat.undefined);
    final frontFace = getMapValue(map, 'frontFace', FrontFace.ccw);
    final cullMode = getMapValue(map, 'cullMode', CullMode.none);
    final unclippedDepth = getMapValue(map, 'unclippedDepth', false);

    return PrimitiveState(
        topology: topology,
        stripIndexFormat: stripIndexFormat,
        frontFace: frontFace,
        cullMode: cullMode,
        unclippedDepth: unclippedDepth);
  }
}
