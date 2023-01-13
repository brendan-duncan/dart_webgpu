#include "../lib_webgpu_dart.h"
#define GLFW_EXPOSE_NATIVE_WIN32
#include <GLFW/glfw3.h>
#include <GLFW/glfw3native.h>
#include <math.h>

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

static int _leftButton = 1;
static int _rightButton = 2;
static int _middleButton = 4;

static int _mouseX = 0;
static int _mouseY = 0;
static int _mouseButton = 0;
void wgpu_window_poll_events(WGpuWindow window) {
    glfwPollEvents();

    int lmb = glfwGetMouseButton((GLFWwindow*)window, GLFW_MOUSE_BUTTON_LEFT);
    int rmb = glfwGetMouseButton((GLFWwindow*)window, GLFW_MOUSE_BUTTON_RIGHT);
    int mmb = glfwGetMouseButton((GLFWwindow*)window, GLFW_MOUSE_BUTTON_RIGHT);
    _mouseButton = (lmb == GLFW_PRESS ? _leftButton : 0) |
        (rmb == GLFW_PRESS ? _rightButton : 0) |
        (mmb == GLFW_PRESS ? _middleButton : 0);

    double x;
    double y;
    glfwGetCursorPos((GLFWwindow*)window, &x, &y);
    _mouseX = floor(x);
    _mouseY = floor(y);
}

int wgpu_window_should_quit(WGpuWindow window) {
    return glfwWindowShouldClose((GLFWwindow*)window);
}

WGpuCanvasContext wgpu_window_get_webgpu_context(WGpuWindow window) {
    HWND hwnd = glfwGetWin32Window((GLFWwindow*)window);
    return wgpu_canvas_get_webgpu_context(hwnd);
}

int wgpu_window_mouse_position_x() {
    return _mouseX;
}

int wgpu_window_mouse_position_y() {
    return _mouseY;
}

int wgpu_window_mouse_button() {
    return _mouseButton;
}

int wgpu_window_get_key(WGpuWindow window, int key) {
    return glfwGetKey((GLFWwindow*)window, key);
}
