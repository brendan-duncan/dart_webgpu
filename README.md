# Dart WebGPU

Dart bindings of the WebGPU graphics API.

## WARNING: Experimental, Work In Progress

Development is on-going, and not everything works.
* Async functions like mapAsync currently trigger a crash in Dawn that
I'm trying to track down. 

## Building WebGPU Bindings

To update the webgpu bindings, run
`python build_libwebgpu.py`

This will download the required third-party libraries, build them, and generate
an updated version of the ffi Dart bindings using ffigen.

### Build Requirements

* git
* Python 3.0+
* CMake 3.15+

### Third Party Libraries

Dart WebGPU uses the following third party libraries:

- Dawn: https://dawn.googlesource.com/dawn
  - This is Google's implementation of WebGPU.
- lib_webgpu: https://github.com/juj/wasm_webgpu
  - This is a wrapper around Dawn that simplifies the API making binding easier.

### Debugging Tips

* Build libwebgpu with `python build_libwebgpu.py`
* Make sure to load the Debug build of the library by adding `wgpu.initializeWebGPU(debug: true);`
to the top of the Dart program.
* Add a breakpoint to the Dart code, run in debugger, pausing execution at the breakpoint.
* Open libwebgpu/_build/Debug/libwebgpu.sln in Visual Studio
* In VS `Debug / Attach To Process...`
  * Find the `dart.exe` process that has the dart program as an argument.
  * Open the lib_webgpu or Dawn cpp file you want to debug in VS, add a breakpoint to the line you want to catch
    with the debugger.
  * Unpause the Dart Debugger
