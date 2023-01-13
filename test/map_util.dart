import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';
import 'package:webgpu/webgpu/_map_util.dart';

void main() async {
  test('map_util', () async {
    final e = mapObject<GPUTextureBindingLayout>({
      'sampleType': 'float',
      'viewDimension': '3d'
    });
    expect(e.sampleType, equals(GPUTextureSampleType.float));
    expect(e.viewDimension, equals(GPUTextureViewDimension.textureView3d));

    final addressModeNullable = mapValueNullable<GPUAddressMode>('repeat');
    expect(addressModeNullable, equals(GPUAddressMode.repeat));
  });
}
