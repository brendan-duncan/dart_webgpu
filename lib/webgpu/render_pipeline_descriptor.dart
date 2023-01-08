import 'depth_stencil_state.dart';
import 'fragment_state.dart';
import 'multisample_state.dart';
import 'primitive_state.dart';
import 'vertex_state.dart';

class RenderPipelineDescriptor {
  final VertexState vertex;
  final PrimitiveState? primitive;
  final DepthStencilState? depthStencil;
  final MultisampleState? multisample;
  final FragmentState? fragment;

  const RenderPipelineDescriptor(
      {required this.vertex,
      this.primitive,
      this.depthStencil,
      this.multisample,
      this.fragment});
}
