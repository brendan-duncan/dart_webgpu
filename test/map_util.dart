import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';
import 'package:webgpu/webgpu/_map_util.dart';

void main() async {
  test('map_util', () async {
    final e = getMapObject<GpuTextureBindingLayout>({
      'sampleType': GpuTextureSampleType.float,
      'viewDimension': GpuTextureViewDimension.textureView2d
    });
    print(e);
  });
}
