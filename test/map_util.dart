import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';
import 'package:webgpu/webgpu/_map_util.dart';

void main() async {
  test('map_util', () async {
    final e = getMapObject<GPUTextureBindingLayout>({
      'sampleType': GPUTextureSampleType.float,
      'viewDimension': GPUTextureViewDimension.textureView2d
    });
    print(e);
  });
}
