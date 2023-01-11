import '_map_util.dart';
import 'query_set.dart';
import 'render_pass_color_attachment.dart';
import 'render_pass_depth_stencil_attachment.dart';
import 'timestamp_write.dart';

class RenderPassDescriptor {
  /// The set of [RenderPassColorAttachment] values in this sequence defines
  /// which color attachments will be output to when executing this render pass.
  ///
  /// Due to usage compatibility, no color attachment may alias another
  /// attachment or any resource used inside the render pass.
  final List<RenderPassColorAttachment> colorAttachments;

  /// The [RenderPassDepthStencilAttachment] value that defines the
  /// depth/stencil attachment that will be output to and tested against when
  /// executing this render pass.
  ///
  /// Due to usage compatibility, no writable depth/stencil attachment may alias
  /// another attachment or any resource used inside the render pass.
  final RenderPassDepthStencilAttachment? depthStencilAttachment;

  /// The [QuerySet] value defines where the occlusion query results will be
  /// stored for this pass.
  final QuerySet? occlusionQuerySet;

  /// The maximum number of draw calls that will be done in the render pass.
  /// Used by some implementations to size work injected before the render pass.
  /// Keeping the default value is a good default, unless it is known that more
  /// draw calls will be done.
  final int maxDrawCount;

  /// A sequence of [TimestampWrite] values defines where and when
  /// timestamp values will be written for this pass.
  final List<TimestampWrite>? timestampWrites;

  const RenderPassDescriptor(
      {required this.colorAttachments,
      this.depthStencilAttachment,
      this.occlusionQuerySet,
      this.maxDrawCount = 50000000,
      this.timestampWrites});

  factory RenderPassDescriptor.fromMap(Map<String, Object> map) {
    final colorAttachments =
        getMapList<RenderPassColorAttachment>(map['colorAttachments']);
    final depthStencilAttachment =
        getMapObjectNullable<RenderPassDepthStencilAttachment>(
            map['depthStencilAttachment']);
    final occlusionQuerySet =
        getMapValue<QuerySet?>(map['occlusionQuerySet'], null);
    final maxDrawCount = getMapValue<int>(map['maxDrawCount'], 50000000);
    final timestampWrites =
        getMapListNullable<TimestampWrite>(map['timestampWrites']);

    return RenderPassDescriptor(
        colorAttachments: colorAttachments,
        depthStencilAttachment: depthStencilAttachment,
        occlusionQuerySet: occlusionQuerySet,
        maxDrawCount: maxDrawCount,
        timestampWrites: timestampWrites);
  }
}
