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
    final topology = getMapValue<PrimitiveTopology>(
        map['topology'], PrimitiveTopology.triangleList);
    final stripIndexFormat = getMapValue<IndexFormat>(
        map['stripIndexFormat'], IndexFormat.undefined);
    final frontFace = getMapValue<FrontFace>(map['frontFace'], FrontFace.ccw);
    final cullMode = getMapValue<CullMode>(map['cullMode'], CullMode.none);
    final unclippedDepth = getMapValue<bool>(map['unclippedDepth'], false);

    return PrimitiveState(
        topology: topology,
        stripIndexFormat: stripIndexFormat,
        frontFace: frontFace,
        cullMode: cullMode,
        unclippedDepth: unclippedDepth);
  }
}
