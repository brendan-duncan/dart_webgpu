#include "lib_webgpu_dawn.h"
#include "lib_webgpu.h"

#ifdef __cplusplus
extern "C" {
#endif

// Wrapper around wgpu_object_destroy for use with Dart Finalizers, to get around a crash with Device
// trying to call the device lost callback when the Device was destroyed by the garbage collection Finalizer
// after the main function has ended.
void wgpu_object_finalize_dart(WGpuObjectBase wgpuObject);

typedef void* WGpuWindow;

WGpuWindow wgpu_create_window(int width, int height, const char *title);

void wgpu_window_poll_events(WGpuWindow window);

int wgpu_window_mouse_position_x();

int wgpu_window_mouse_position_y();

int wgpu_window_mouse_button();

int wgpu_window_get_key(WGpuWindow window, int key);

int wgpu_window_should_quit(WGpuWindow window);

WGpuCanvasContext wgpu_window_get_webgpu_context(WGpuWindow window);

#ifdef __cplusplus
} // ~extern "C"
#endif
