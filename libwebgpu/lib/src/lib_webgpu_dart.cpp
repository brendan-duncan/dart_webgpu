#include "../lib_webgpu_dart.h"
#define GLFW_EXPOSE_NATIVE_WIN32
#include <GLFW/glfw3.h>
#include <GLFW/glfw3native.h>

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

WGpuWindow wgpu_create_window(int width, int height, const char *title) {
    if (!glfwInit()) {
        return nullptr;
    }

    glfwWindowHint(GLFW_CLIENT_API, GLFW_NO_API);
    glfwWindowHint(GLFW_COCOA_RETINA_FRAMEBUFFER, GLFW_FALSE);
    GLFWwindow* window = glfwCreateWindow(width, height, title, nullptr, nullptr);

    return window;
}

void wgpu_window_poll_events() {
    glfwPollEvents();
}

int wgpu_window_should_quit(WGpuWindow window) {
    return glfwWindowShouldClose((GLFWwindow*)window);
}

WGpuCanvasContext wgpu_window_get_webgpu_context(WGpuWindow window) {
    HWND hwnd = glfwGetWin32Window((GLFWwindow*)window);
    return wgpu_canvas_get_webgpu_context(hwnd);
}
