import 'package:test/test.dart';
import 'package:webgpu/webgpu.dart';
import 'package:webgpu/webgpu/_map_util.dart';

void main() async {
  test('map_util', () async {
    final e = getMapObject<TextureBindingLayout>({
      'sampleType': TextureSampleType.float,
      'viewDimension': TextureViewDimension.textureView2d
    });
    print(e);
  });
}
