/// Indicates the required type of a Sampler bound to this bindings.
enum GPUSamplerBindingType {
  filtering,
  nonFiltering,
  comparison;

  static GPUSamplerBindingType fromString(String s) {
    switch (s) {
      case 'filtering':
        return GPUSamplerBindingType.filtering;
      case 'non-filtering':
        return GPUSamplerBindingType.nonFiltering;
      case 'comparison':
        return GPUSamplerBindingType.comparison;
    }
    throw Exception('Invalid value for GPUSamplerBindingType');
  }

  int get nativeIndex => index + 1;
}
