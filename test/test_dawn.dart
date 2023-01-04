import 'package:webgpu/webgpu.dart' as webgpu;

void main() async {
  final adapter = await webgpu.Adapter.request(
      webgpu.AdapterOptions());

  print(adapter.features);
  print(adapter.limits);

  final device = await adapter.requestDevice(
      webgpu.DeviceDescriptor(requiredFeatures: adapter.features,
        requiredLimits: adapter.limits));

  print(device.features);
}
