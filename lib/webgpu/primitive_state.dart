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
}
