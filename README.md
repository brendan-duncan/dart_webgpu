# dart_webgpu
Dart bindings of the WebGPU graphics API


## Building

To build the webgpu bindings, run
`python build_libwebgpu.py`

This will pull Dawn and lib_webgpu from git, build them, and build the ffi Dart
bindings.

### Requirements

* git
* Python 3.0+
* CMake 3.15+
* Dart ffigen package
