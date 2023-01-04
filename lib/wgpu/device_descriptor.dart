import 'features.dart';
import 'limits.dart';
import 'queue_descriptor.dart';

class DeviceDescriptor {
  Features? requiredFeatures;
  Limits? requiredLimits;
  QueueDescriptor? defaultQueue;

  DeviceDescriptor(
      {this.requiredFeatures, this.requiredLimits, this.defaultQueue});
}
