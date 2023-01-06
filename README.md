# Dart WebGPU

Dart bindings of the WebGPU graphics API.


## Building WebGPU Bindings

To update the webgpu bindings, run
`python build_libwebgpu.py`

This will download the required third-party libraries, build them, and generate
an updated version of the ffi Dart bindings using ffigen.

### Build Requirements

* git
* Python 3.0+
* CMake 3.15+
* Dart ffigen package

### Third Party Libraries

Dart WebGPU uses the following third party libraries:

- Dawn: https://dawn.googlesource.com/dawn
  - This is Google's implementation of WebGPU.
- lib_webgpu: https://github.com/juj/wasm_webgpu
  - This is a wrapper around Dawn that simplifies the API making binding simpler.
