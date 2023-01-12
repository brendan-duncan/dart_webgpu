import '_map_util.dart';
import 'gpu_query_set.dart';
import 'gpu_render_pass_color_attachment.dart';
import 'gpu_render_pass_depth_stencil_attachment.dart';
import 'gpu_timestamp_write.dart';

class GpuRenderPassDescriptor {
  /// The set of [GpuRenderPassColorAttachment] values in this sequence defines
  /// which color attachments will be output to when executing this render pass.
  ///
  /// Due to usage compatibility, no color attachment may alias another
  /// attachment or any resource used inside the render pass.
  final List<GpuRenderPassColorAttachment> colorAttachments;

  /// The [GpuRenderPassDepthStencilAttachment] value that defines the
  /// depth/stencil attachment that will be output to and tested against when
  /// executing this render pass.
  ///
  /// Due to usage compatibility, no writable depth/stencil attachment may alias
  /// another attachment or any resource used inside the render pass.
  final GpuRenderPassDepthStencilAttachment? depthStencilAttachment;

  /// The [GpuQuerySet] value defines where the occlusion query results will be
  /// stored for this pass.
  final GpuQuerySet? occlusionQuerySet;

  /// The maximum number of draw calls that will be done in the render pass.
  /// Used by some implementations to size work injected before the render pass.
  /// Keeping the default value is a good default, unless it is known that more
  /// draw calls will be done.
  final int maxDrawCount;

  /// A sequence of [GpuTimestampWrite] values defines where and when
  /// timestamp values will be written for this pass.
  final List<GpuTimestampWrite>? timestampWrites;

  const GpuRenderPassDescriptor(
      {required this.colorAttachments,
      this.depthStencilAttachment,
      this.occlusionQuerySet,
      this.maxDrawCount = 50000000,
      this.timestampWrites});

  factory GpuRenderPassDescriptor.fromMap(Map<String, Object> map) {
    final colorAttachments =
        getMapList<GpuRenderPassColorAttachment>(map['colorAttachments']);
    final depthStencilAttachment =
        getMapObjectNullable<GpuRenderPassDepthStencilAttachment>(
            map['depthStencilAttachment']);
    final occlusionQuerySet =
        getMapValue<GpuQuerySet?>(map['occlusionQuerySet'], null);
    final maxDrawCount = getMapValue<int>(map['maxDrawCount'], 50000000);
    final timestampWrites =
        getMapListNullable<GpuTimestampWrite>(map['timestampWrites']);

    return GpuRenderPassDescriptor(
        colorAttachments: colorAttachments,
        depthStencilAttachment: depthStencilAttachment,
        occlusionQuerySet: occlusionQuerySet,
        maxDrawCount: maxDrawCount,
        timestampWrites: timestampWrites);
  }
}
