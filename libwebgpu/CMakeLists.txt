cmake_minimum_required(VERSION 3.15 FATAL_ERROR)
project(libwebgpu VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
add_definitions(-D_ITERATOR_DEBUG_LEVEL=0)

add_library(webgpu SHARED
    libwebgpu.def
    src/lib_webgpu.cpp
    src/lib_webgpu_cpp11.cpp
    src/lib_webgpu_dawn.cpp
)
    
target_link_directories(webgpu PUBLIC "dawn/libs/win-x64-$<$<CONFIG:Debug>:Debug>$<$<CONFIG:Release>:Release>")

target_include_directories(webgpu PUBLIC dawn/include)

set_property(TARGET webgpu PROPERTY
  MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>DLL")

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
)

set_target_properties(webgpu PROPERTIES
    PUBLIC_HEADER lib_webgpu/lib_webgpu.h
    VERSION ${PROJECT_VERSION}
    SOVERSION 1
    OUTPUT_NAME "webgpu"
)
