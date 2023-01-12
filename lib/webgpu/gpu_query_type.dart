enum GPUQueryType {
  /// Occlusion query is only available on render passes, to query the number of
  /// fragment samples that pass all the per-fragment tests for a set of drawing
  /// commands, including scissor, sample mask, alpha to coverage, stencil, and
  /// depth tests. Any non-zero result value for the query indicates that at
  /// least one sample passed the tests and reached the output merging stage of
  /// the render pipeline, 0 indicates that no samples passed the tests.
  ///
  /// When beginning a render pass, RenderPassDescriptor.occlusionQuerySet
  /// must be set to be able to use occlusion queries during the pass. An
  /// occlusion query is begun and ended by calling beginOcclusionQuery() and
  /// endOcclusionQuery() in pairs that cannot be nested.
  occlusion,

  /// Timestamp queries allow applications to write timestamps to a QuerySet,
  /// using:
  /// CommandEncoder.writeTimestamp()
  /// ComputePassDescriptor.timestampWrites
  /// RenderPassDescriptor.timestampWrites
  /// and then resolve timestamp values (in nanoseconds as a unsigned integer)
  /// into a Buffer, using CommandEncoder.resolveQuerySet().
  ///
  /// Timestamp query requires "timestamp-query" to be enabled for the device.
  timestamp;

  static GPUQueryType fromString(String s) {
    switch (s) {
      case 'occlusion':
        return GPUQueryType.occlusion;
      case 'timestamp':
        return GPUQueryType.timestamp;
    }
    throw Exception('Invalid value for GPUQueryType');
  }

  int get nativeIndex => index + 1;
}
