#include "../lib_webgpu_dart.h"

void* wgpu_buffer_get_mapped_range_dart(WGpuBuffer buffer, double_int53_t startOffset,
    double_int53_t size) {
    void* ptr = (void*)wgpu_buffer_get_mapped_range(buffer, startOffset, size);
    return ptr;
}

void wgpu_object_finalize_dart(WGpuObjectBase wgpuObject) {
    if (wgpuObject->type == 2) { // kWebGPUDevice
        // Dart FFI Finalizer is crashing if the main function ends, invoking the Finalizer for a Device,
        // which has a device lost callback. The callback can't be called after the main function has ended.
        // I don't know how to detect if the main function is running to prevent this from happening,
        // so for now just remove the lost device callback any time the Device is destroyed because of the
        // Finalizer.
        wgpu_device_set_lost_callback(wgpuObject, nullptr, nullptr);
    }
    wgpu_object_destroy(wgpuObject);
}
