# This should be run from build_libwebgpu.py
cmake_minimum_required(VERSION 3.15 FATAL_ERROR)

set(CMAKE_OSX_DEPLOYMENT_TARGET "10.13" CACHE STRING "Minimum OS X deployment version")

project(libwebgpu VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)

add_library(webgpu SHARED
    libwebgpu.def
    _build/lib_webgpu/lib/lib_webgpu.cpp
    _build/lib_webgpu/lib/lib_webgpu_cpp11.cpp
    _build/lib_webgpu/lib/lib_webgpu_dawn.cpp
    lib/src/lib_webgpu_dart.cpp
)

target_include_directories(webgpu PUBLIC _build/dawn_libs/include)

set_property(TARGET webgpu PROPERTY
    MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL") # /MD

if(APPLE)
target_link_directories(webgpu PUBLIC "_build/dawn_libs/mac-arm64-${CMAKE_BUILD_TYPE}")
target_link_libraries(webgpu PUBLIC
    "-framework Cocoa"
    "-framework Metal"
    "-framework IOKit"
    "-framework IOSurface"
    "-framework QuartzCore"
    libabsl_strings_internal.a
    libabsl_throw_delegate.a
    libdawn_common.a
    libdawn_headers.a
    libdawn_native.a
    libdawn_platform.a
    libdawn_proc.a
    libdawn_utils.a
    libdawn_wire.a
    libSPIRV-Tools.a
    libSPIRV-Tools-opt.a
    libtint.a
    libtint_diagnostic_utils.a
    libtint_utils_io.a
    libtint_val.a
    libabsl_base.a
    libabsl_int128.a
    libabsl_log_severity.a
    libabsl_raw_logging_internal.a
    libabsl_spinlock_wait.a
    libabsl_str_format_internal.a
    libabsl_strings.a
    libglfw3.a
)
endif()

if(WIN32)
target_link_directories(webgpu PUBLIC "_build/dawn_libs/win-x64-${CMAKE_BUILD_TYPE}")
target_link_libraries(webgpu PUBLIC
    absl_strings_internal.lib
    absl_throw_delegate.lib
    dawn_common.lib
    dawn_headers.lib
    dawn_native.lib
    dawn_platform.lib
    dawn_proc.lib
    dawn_utils.lib
    dawn_wire.lib
    SPIRV-Tools.lib
    SPIRV-Tools-opt.lib
    tint.lib
    tint_diagnostic_utils.lib
    tint_utils_io.lib
    tint_val.lib
    absl_base.lib
    absl_int128.lib
    absl_log_severity.lib
    absl_raw_logging_internal.lib
    absl_spinlock_wait.lib
    absl_str_format_internal.lib
    absl_strings.lib
    dxguid.lib
    glfw3.lib
)
endif()