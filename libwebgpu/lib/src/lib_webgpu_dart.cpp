#include "../lib_webgpu_dart.h"

void* wgpu_buffer_get_mapped_range_dart(WGpuBuffer buffer, double_int53_t startOffset,
    double_int53_t size) {
    void* ptr = (void*)wgpu_buffer_get_mapped_range(buffer, startOffset, size);
    return ptr;
}
