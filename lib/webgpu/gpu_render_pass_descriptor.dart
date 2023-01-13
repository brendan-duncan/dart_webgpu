import '_map_util.dart';
import 'gpu_query_set.dart';
import 'gpu_render_pass_color_attachment.dart';
import 'gpu_render_pass_depth_stencil_attachment.dart';
import 'gpu_timestamp_write.dart';

class GPURenderPassDescriptor {
  /// The set of [GPURenderPassColorAttachment] values in this sequence defines
  /// which color attachments will be output to when executing this render pass.
  ///
  /// Due to usage compatibility, no color attachment may alias another
  /// attachment or any resource used inside the render pass.
  final List<GPURenderPassColorAttachment> colorAttachments;

  /// The [GPURenderPassDepthStencilAttachment] value that defines the
  /// depth/stencil attachment that will be output to and tested against when
  /// executing this render pass.
  ///
  /// Due to usage compatibility, no writable depth/stencil attachment may alias
  /// another attachment or any resource used inside the render pass.
  final GPURenderPassDepthStencilAttachment? depthStencilAttachment;

  /// The [GPUQuerySet] value defines where the occlusion query results will be
  /// stored for this pass.
  final GPUQuerySet? occlusionQuerySet;

  /// The maximum number of draw calls that will be done in the render pass.
  /// Used by some implementations to size work injected before the render pass.
  /// Keeping the default value is a good default, unless it is known that more
  /// draw calls will be done.
  final int maxDrawCount;

  /// A sequence of [GPUTimestampWrite] values defines where and when
  /// timestamp values will be written for this pass.
  final List<GPUTimestampWrite>? timestampWrites;

  const GPURenderPassDescriptor(
      {required this.colorAttachments,
      this.depthStencilAttachment,
      this.occlusionQuerySet,
      this.maxDrawCount = 50000000,
      this.timestampWrites});

  factory GPURenderPassDescriptor.fromMap(Map<String, Object> map) {
    final colorAttachments =
        mapList<GPURenderPassColorAttachment>(map['colorAttachments']);
    final depthStencilAttachment =
        mapObjectNullable<GPURenderPassDepthStencilAttachment>(
            map['depthStencilAttachment']);
    final occlusionQuerySet =
      mapValueNullable<GPUQuerySet>(map['occlusionQuerySet']);
    final maxDrawCount = mapValue<int>(map['maxDrawCount'], 50000000);
    final timestampWrites =
        mapListNullable<GPUTimestampWrite>(map['timestampWrites']);

    return GPURenderPassDescriptor(
        colorAttachments: colorAttachments,
        depthStencilAttachment: depthStencilAttachment,
        occlusionQuerySet: occlusionQuerySet,
        maxDrawCount: maxDrawCount,
        timestampWrites: timestampWrites);
  }
}
