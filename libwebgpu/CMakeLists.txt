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
        #GenericCodeGend.lib
        #glslang-default-resource-limitsd.lib
        #glslangd.lib
        #libprotobuf-lited.lib
        #libprotobufd.lib
        #libprotocd.lib
        #MachineIndependentd.lib
        #OSDependentd.lib
    )

    target_link_libraries(webgpu PUBLIC
        dxguid.lib
        absl_bad_any_cast_impl.lib
        absl_bad_optional_access.lib
        absl_bad_variant_access.lib
        absl_base.lib
        absl_city.lib
        absl_civil_time.lib
        absl_cord.lib
        absl_cordz_functions.lib
        absl_cordz_handle.lib
        absl_cordz_info.lib
        absl_cordz_sample_token.lib
        absl_cord_internal.lib
        absl_crc32c.lib
        absl_crc_cord_state.lib
        absl_crc_cpu_detect.lib
        absl_crc_internal.lib
        absl_debugging_internal.lib
        absl_demangle_internal.lib
        absl_die_if_null.lib
        absl_examine_stack.lib
        absl_exponential_biased.lib
        absl_failure_signal_handler.lib
        absl_flags_commandlineflag.lib
        absl_flags_commandlineflag_internal.lib
        absl_flags_config.lib
        absl_flags_internal.lib
        absl_flags_marshalling.lib
        absl_flags_parse.lib
        absl_flags_private_handle_accessor.lib
        absl_flags_program_name.lib
        absl_flags_reflection.lib
        absl_flags_usage.lib
        absl_flags_usage_internal.lib
        absl_graphcycles_internal.lib
        absl_hash.lib
        absl_hashtablez_sampler.lib
        absl_int128.lib
        absl_kernel_timeout_internal.lib
        absl_leak_check.lib
        absl_log_entry.lib
        absl_log_flags.lib
        absl_log_globals.lib
        absl_log_initialize.lib
        absl_log_internal_check_op.lib
        absl_log_internal_conditions.lib
        absl_log_internal_fnmatch.lib
        absl_log_internal_format.lib
        absl_log_internal_globals.lib
        absl_log_internal_log_sink_set.lib
        absl_log_internal_message.lib
        absl_log_internal_nullguard.lib
        absl_log_internal_proto.lib
        absl_log_severity.lib
        absl_log_sink.lib
        absl_low_level_hash.lib
        absl_malloc_internal.lib
        absl_periodic_sampler.lib
        absl_random_distributions.lib
        absl_random_internal_distribution_test_util.lib
        absl_random_internal_platform.lib
        absl_random_internal_pool_urbg.lib
        absl_random_internal_randen.lib
        absl_random_internal_randen_hwaes.lib
        absl_random_internal_randen_hwaes_impl.lib
        absl_random_internal_randen_slow.lib
        absl_random_internal_seed_material.lib
        absl_random_seed_gen_exception.lib
        absl_random_seed_sequences.lib
        absl_raw_hash_set.lib
        absl_raw_logging_internal.lib
        absl_scoped_set_env.lib
        absl_spinlock_wait.lib
        absl_stacktrace.lib
        absl_status.lib
        absl_statusor.lib
        absl_strerror.lib
        absl_strings.lib
        absl_strings_internal.lib
        absl_string_view.lib
        absl_str_format_internal.lib
        absl_symbolize.lib
        absl_synchronization.lib
        absl_throw_delegate.lib
        absl_time.lib
        absl_time_zone.lib
        absl_vlog_config_internal.lib
        dawn_common.lib
        dawn_glfw.lib
        dawn_native.lib
        dawn_native_objects.lib
        dawn_platform.lib
        dawn_proc.lib
        dawn_sample_utils.lib
        dawn_system_utils.lib
        dawn_test_utils.lib
        dawn_wgpu_utils.lib
        dawn_wire.lib
        glfw3.lib
        SPIRV-Tools-opt.lib
        SPIRV-Tools.lib
        tint_api.lib
        tint_api_common.lib
        tint_cmd_common.lib
        tint_lang_core.lib
        tint_lang_core_common.lib
        tint_lang_core_constant.lib
        tint_lang_core_intrinsic.lib
        tint_lang_core_ir.lib
        tint_lang_core_ir_transform.lib
        tint_lang_core_ir_type.lib
        tint_lang_core_type.lib
        tint_lang_glsl_validate.lib
        tint_lang_hlsl.lib
        tint_lang_hlsl_intrinsic.lib
        tint_lang_hlsl_ir.lib
        tint_lang_hlsl_type.lib
        tint_lang_hlsl_validate.lib
        tint_lang_hlsl_writer.lib
        tint_lang_hlsl_writer_ast_printer.lib
        tint_lang_hlsl_writer_ast_raise.lib
        tint_lang_hlsl_writer_common.lib
        tint_lang_hlsl_writer_helpers.lib
        tint_lang_hlsl_writer_printer.lib
        tint_lang_hlsl_writer_raise.lib
        tint_lang_spirv.lib
        tint_lang_spirv_intrinsic.lib
        tint_lang_spirv_ir.lib
        tint_lang_spirv_reader.lib
        tint_lang_spirv_reader_ast_lower.lib
        tint_lang_spirv_reader_ast_parser.lib
        tint_lang_spirv_reader_common.lib
        tint_lang_spirv_reader_lower.lib
        tint_lang_spirv_reader_parser.lib
        tint_lang_spirv_type.lib
        tint_lang_spirv_validate.lib
        tint_lang_spirv_writer.lib
        tint_lang_spirv_writer_common.lib
        tint_lang_spirv_writer_helpers.lib
        tint_lang_spirv_writer_printer.lib
        tint_lang_spirv_writer_raise.lib
        tint_lang_wgsl.lib
        tint_lang_wgsl_ast.lib
        tint_lang_wgsl_ast_transform.lib
        tint_lang_wgsl_common.lib
        tint_lang_wgsl_features.lib
        tint_lang_wgsl_helpers.lib
        tint_lang_wgsl_inspector.lib
        tint_lang_wgsl_intrinsic.lib
        tint_lang_wgsl_ir.lib
        tint_lang_wgsl_program.lib
        tint_lang_wgsl_reader.lib
        tint_lang_wgsl_reader_lower.lib
        tint_lang_wgsl_reader_parser.lib
        tint_lang_wgsl_reader_program_to_ir.lib
        tint_lang_wgsl_resolver.lib
        tint_lang_wgsl_sem.lib
        tint_lang_wgsl_writer.lib
        tint_lang_wgsl_writer_ast_printer.lib
        tint_lang_wgsl_writer_ir_to_program.lib
        tint_lang_wgsl_writer_raise.lib
        tint_lang_wgsl_writer_syntax_tree_printer.lib
        tint_utils.lib
        tint_utils_command.lib
        tint_utils_containers.lib
        tint_utils_diagnostic.lib
        tint_utils_file.lib
        tint_utils_ice.lib
        tint_utils_macros.lib
        tint_utils_math.lib
        tint_utils_memory.lib
        tint_utils_result.lib
        tint_utils_rtti.lib
        tint_utils_strconv.lib
        tint_utils_symbol.lib
        tint_utils_system.lib
        tint_utils_text.lib
        VulkanLayerSettings.lib
        VulkanSafeStruct.lib
        webgpu_dawn.lib
    )
endif()