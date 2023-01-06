#include "lib_webgpu.h"

// lib_webgpu returns the pointer mapped to a uint64, to be consistent with the Javascript backend.
// To simplify ffi binding, wrap the function to a have it return a pointer instead.
void* wgpu_buffer_get_mapped_range_dart(WGpuBuffer buffer, double_int53_t startOffset,
    double_int53_t size _WGPU_DEFAULT_VALUE(WGPU_MAP_MAX_LENGTH));
