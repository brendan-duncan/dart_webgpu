#include "lib_webgpu.h"

// lib_webgpu returns the pointer mapped to a uint64, to be consistent with the Javascript backend.
// To simplify ffi binding, wrap the function to a have it return a pointer instead.
void* wgpu_buffer_get_mapped_range_dart(WGpuBuffer buffer, double_int53_t startOffset,
    double_int53_t size _WGPU_DEFAULT_VALUE(WGPU_MAP_MAX_LENGTH));

// Wrapper around wgpu_object_destroy for use with Dart Finalizers, to get around a crash with Device
// trying to call the device lost callback when the Device was destroyed by the garbage collection Finalizer
// after the main function has ended.
void wgpu_object_finalize_dart(WGpuObjectBase wgpuObject);

typedef void* WGpuWindow;

WGpuWindow wgpu_create_window(int width, int height, const char *title);

void wgpu_window_poll_events();

int wgpu_window_should_quit(WGpuWindow window);

WGpuCanvasContext wgpu_window_get_webgpu_context(WGpuWindow window);
