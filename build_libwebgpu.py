import errno
import glob
import os
import platform
import shutil
import subprocess
import sys


WINDOWS = os.name == 'nt'
LINUX = platform.system() == 'Linux'
MAC = platform.mac_ver()[0] != ''


# Returns an OS identifier for generated artifact files
def os_name():
    if WINDOWS:
        return 'win'
    if LINUX:
        return 'linux'
    if MAC:
        return 'mac'
    raise Exception('No OS set!')


# Returns a CPU architecture identifier for generated artifact files
def arch_name():
    machine = platform.machine().lower()
    if machine in ['aarch64', 'aarch64_be', 'arm64', 'armv8b', 'armv8l']:
        return 'arm64'
    if machine in ['amd64', 'x86_64', 'x64']:
        return 'x64'
    return machine


# Enables a with cwd("foo") construct to safely enter and exit a current directory
class cwd:
    def __init__(self, new_path):
        self.new_path = os.path.expanduser(new_path)

    def __enter__(self):
        self.saved_path = os.getcwd()
        os.chdir(self.new_path)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.saved_path)


def exe_suffix(path):
    if WINDOWS:
        return path + '.exe'
    else:
        return path


# Runs given cmdline cmd in the given current working directory
def run(cmd, working_directory='.'):
    with cwd(working_directory):
        print('####', ' '.join(cmd))
        return subprocess.check_call(cmd)


# Recursively creates the given directory tree.
# http://stackoverflow.com/questions/600268/mkdir-p-functionality-in-python
def mkdir_p(path):
    if os.path.exists(path):
        return
    try:
        os.makedirs(path)
    except IOError as exc:  # Python >2.5
        if exc.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


def delete_file_if_exists(filename):
    try:
        print('Deleting file ' + filename)
        os.remove(filename)
    except IOError:
        pass


def delete_directory_if_exists(directory):
    try:
        print('Deleting directory ' + directory)
        shutil.rmtree(directory)
    except IOError:
        pass


# Returns a path specifier to the given command in the current working directory (i.e. './foo' vs 'foo' on Mac/Linux
# vs Windows)
def cmd_in_cwd(cmd):
    if WINDOWS:
        return cmd
    return './' + cmd


def which(program, hint_paths=None, must_find=True):
    def is_exe(fp):
        return os.path.isfile(fp) and os.access(fp, os.X_OK)

    fpath, fname = os.path.split(program)
    if fpath:
        if is_exe(program):
            return program
    else:
        for path in os.environ["PATH"].split(os.pathsep):
            path = path.strip('"')
            exe_file = os.path.join(path, program)
            if is_exe(exe_file):
                return exe_file

            if WINDOWS and '.' not in fname:
                if is_exe(exe_file + '.exe'):
                    return exe_file + '.exe'
                if is_exe(exe_file + '.cmd'):
                    return exe_file + '.cmd'
                if is_exe(exe_file + '.bat'):
                    return exe_file + '.bat'

    if hint_paths:
        for path in hint_paths:
            if os.path.isfile(os.path.join(path, program)):
                return os.path.join(path, program)
            if WINDOWS and '.' not in program:
                if os.path.isfile(os.path.join(path, program + '.exe')):
                    return os.path.join(path, program + '.exe')
                if os.path.isfile(os.path.join(path, program + '.com')):
                    return os.path.join(path, program + '.com')
                if os.path.isfile(os.path.join(path, program + '.bat')):
                    return os.path.join(path, program + '.bat')

    if must_find:
        raise Exception('Tool "' + program + '" was not found in PATH! Unable to proceed!')

    return None


def cmake():
    return which('cmake')


def git():
    return which('git')


# Ensures that the given dest_dir directory contains the specified git repository checkout, with given ref (
# branch/tag/git hash) checked out to it. clone_strategy: one of 'fast-forward': The existing repository is
# fast-forwarded to the desired hash (do not erase any modified files) 'reset-hard': The existing checkout is
# forcibly updated to the desired hash (local changes are lost), 'full-clean': The existing checkout is forcibly
# updated to the desired hash, and additionally all local untracked files are deleted.
def git_clone_and_update_to(git_repository_url, dest_dir, repository_ref, clone_strategy='fast-forward'):
    if clone_strategy not in ['fast-forward', 'reset-hard', 'full-clean']:
        raise Exception('Unknown clone_strategy ' + str(
            clone_strategy) + "! Should be one of 'fast-forward', 'reset-hard', 'full-clean'")

    dest_dir = os.path.abspath(dest_dir)

    # Sanity guard: Only create up to two subdirectories for dest_dir, otherwise regard it as malformed!
    parent_dir = os.path.dirname(dest_dir)
    parent_parent_dir = os.path.dirname(dest_dir)
    if not os.path.isdir(dest_dir) and not os.path.isdir(parent_dir) and not not os.path.isdir(parent_parent_dir):
        raise Exception("Invalid path '" + dest_dir + '"?')

    # If repository does not exist, clone it
    if not os.path.isdir(dest_dir):
        mkdir_p(dest_dir)

        run([git(), 'clone', git_repository_url, dest_dir], dest_dir)
    else:
        # Repository exists, fetch new content
        run([git(), 'fetch'], dest_dir)

    run([git(), 'checkout', repository_ref], dest_dir)

    # Check out the given ref
    if clone_strategy in ['reset-hard', 'full-clean']:
        run([git(), 'reset', '--hard', repository_ref], dest_dir)
    elif clone_strategy == 'fast-forward':
        run([git(), 'merge', '--ff-only', repository_ref], dest_dir)

    # Clean untracked files if requested
    if clone_strategy == 'full-clean':
        run([git(), 'clean', '-xdfq'], dest_dir)


# Copies all files from src to dst, but ignores ones with specific suffixes and file basenames
def copy_all_files_in_dir(srcdir, only_suffixes, ignore_basenames, dstdir, recursive=True):
    if not os.path.isdir(dstdir):
        mkdir_p(dstdir)

    for f in os.listdir(srcdir):
        basename, ext = os.path.splitext(f)
        if ext.startswith('.'):
            ext = ext[1:]
        if len(only_suffixes) > 0 and ext != "" and ext not in only_suffixes:
            continue
        if basename in ignore_basenames or f in ignore_basenames:
            continue

        fn = os.path.join(srcdir, f)
        if os.path.islink(fn):
            linkto = os.readlink(fn)
            print('Creating link ' + os.path.join(dstdir, f) + ' -> ' + linkto)
            os.symlink(linkto, os.path.join(dstdir, f))
        elif recursive and os.path.isdir(fn):
            copy_all_files_in_dir(fn, only_suffixes, ignore_basenames, os.path.join(dstdir, f), recursive)
        elif os.path.isfile(fn):
            dst_file = os.path.join(dstdir, f)
            try:
                shutil.copyfile(fn, dst_file)
                # On Windows the file read only bits from DLLs in Program Files are copied, which is not desirable.
                if not WINDOWS:
                    shutil.copymode(fn, dst_file)
            except shutil.SameFileError:
                pass


def fixupDawnCMake():
    print('#### Fixup Dawn CMake')
    fp = open('CMakeLists.txt', 'rt')
    txt = fp.read()
    fp.close()

    modified = False
    if MAC:
        # On arm64 macOS, poison-system-directories is causing the build to fail when called from
        # Python. I don't know why calling CMake from Python makes CMake think it's a cross-platform build
        # whereas calling CMake from the terminal does not. Add no-poison-system-directories to the Clang
        # warning flags to disable the check.
        if txt.find("-Wno-poison-system-directories") == -1:
            txt = txt.replace("-Weverything", "-Weverything\n    -Wno-poison-system-directories")
            modified = True

    if WINDOWS:
        # Disable warnings as errors because for whatever reason, there are warnings in the build
        if txt.find('/WX') != -1:
            txt = txt.replace("/WX", "")
            modified = True

    if modified:
        print('#### WRITING MODIFIED CMakeLists TO', os.getcwd())
        fp = open('CMakeLists.txt', 'wt')
        fp.write(txt)
        fp.close()


def gclient(depot_tools_path):
    if WINDOWS:
        return os.path.join(depot_tools_path, 'gclient.bat')
    if MAC:
        return os.path.join(depot_tools_path, 'gclient')
    if LINUX:
        return os.path.join(depot_tools_path, 'gclient')
    raise Exception('No OS set!')


def prepareDawnForBuild(env, depot_tools_path):
    shutil.copyfile('scripts/standalone.gclient', '.gclient')
    print("#### RUNNING gclient sync")
    subprocess.run([gclient(depot_tools_path), 'sync'], env=env)
    fixupDawnCMake()


def findLibraries(config):
    libs = []
    baseDir = os.path.join('libwebgpu', '_build', 'dawn', f'out-{config}')
    filter = os.path.normpath(f'**/*.lib')
    for filename in glob.glob(filter, recursive=True):
        filename = os.path.normpath(filename)
        libs.append(filename)
    return libs


def buildDawn():
    path = os.getcwd()
    build_path = os.path.join(path, '_build')
    dawn_path = os.path.join(build_path, 'dawn')
    depot_tools_path = os.path.join(build_path, 'depot_tools')
    dawn_libs_path = os.path.join(build_path, 'dawn_libs')

    arch = arch_name()

    dawn_clone_strategy = 'fast-forward'
    dawn_url = 'https://dawn.googlesource.com/dawn'
    dawn_ref = 'main'

    depot_tools_clone_url = 'https://chromium.googlesource.com/chromium/tools/depot_tools.git'
    depot_tools_ref = 'main'
    depot_tools_clone_strategy = 'fast-forward'

    print("#### CLONING depot_toolS from", depot_tools_clone_url)
    git_clone_and_update_to(depot_tools_clone_url, depot_tools_path, depot_tools_ref,
                            clone_strategy=depot_tools_clone_strategy)

    print("#### CLONING Dawn from", dawn_url)
    git_clone_and_update_to(dawn_url, dawn_path, dawn_ref, clone_strategy=dawn_clone_strategy)

    env = os.environ.copy()
    # Add depot_tools to the path
    env['PATH'] = depot_tools_path + ':' + env['PATH']

    if WINDOWS:
        # Make sure depot_tools uses the local development env and doesn't try to download VS from googlesource.
        env['DEPOT_TOOLS_WIN_TOOLCHAIN'] = '0'

    with cwd(dawn_path):
        print("#### PREPARING Dawn FOR BUILD")
        prepareDawnForBuild(env, depot_tools_path)

        configs = ['Debug']#, 'Release', 'RelWithDebInfo']
        for config in configs:
            out_dir = f'out-{config}'
            mkdir_p(out_dir)
            out_path = os.path.join(dawn_path, out_dir)

            with cwd(out_path):
                print("#### RUNNING CMake in", os.getcwd(), 'for', config)

                config_cmd = [cmake(), '-Wno-dev', '-Wno-poison-system-directories']
                config_cmd.append(f'-DCMAKE_BUILD_TYPE={config}')
                config_cmd.append('-DTINT_BUILD_SPV_READER=1')
                config_cmd.append('-DTINT_BUILD_WGSL_WRITER=1')
                config_cmd.append('-DTINT_BUILD_TESTS=0')
                config_cmd.append('-DTINT_BUILD_DOCS=0')
                config_cmd.append('-DTINT_BUILD_DOCS=0')
                #config_cmd.append('-DTINT_BUILD_SAMPLES=0')
                #config_cmd.append('-DDAWN_BUILD_SAMPLES=0')
                #config_cmd.append('-DBUILD_SAMPLES=0')

                if MAC:
                    config_cmd.append('-G Xcode')
                    if arch == 'arm64':
                        config_cmd.append('-DCMAKE_OSX_ARCHITECTURES=arm64')
                        config_cmd.append('-DCMAKE_SYSTEM_PROCESSOR=arm64')
                    else:
                        config_cmd.append('-DCMAKE_OSX_ARCHITECTURES=x86_64')
                        config_cmd.append('-DCMAKE_SYSTEM_PROCESSOR=x86_64')
                    config_cmd.append('-DCMAKE_OSX_DEPLOYMENT_TARGET=10.13')
                elif WINDOWS:
                    config_cmd.append('-DCMAKE_GENERATOR_PLATFORM=x64')
                    config_cmd.append('-DMSVC_RUNTIME_LIBRARY=MultiThreaded')

                config_cmd.append('..')

                run(config_cmd, out_path)

                print("#### BUILDING Dawn", config, "IN", os.getcwd())
                run([cmake(), '--build', '.', '--config', config], out_path)

                libraries = findLibraries(config)

                lib_dawn_dest_path = os.path.join(dawn_libs_path,
                                                  os_name() + '-' + arch + '-' + config)
                mkdir_p(lib_dawn_dest_path)

                for libPath in libraries:
                    print('# COPY', os.getcwd() + '/' + libPath)
                    out_path = os.path.join(lib_dawn_dest_path, os.path.basename(libPath))
                    shutil.copyfile(libPath, out_path)

            copy_all_files_in_dir(os.path.join(dawn_path, 'include'), [], [],
                                  os.path.join(dawn_libs_path, 'include'), recursive=True)

            gen_path = os.path.join(dawn_path, out_dir, 'gen', 'include')
            copy_all_files_in_dir(gen_path, [], [], os.path.join(dawn_libs_path, 'include'),
                                  recursive=True)

            glfw_path = os.path.join(dawn_path, 'third_party', 'glfw', 'include')
            copy_all_files_in_dir(glfw_path, [], [],
                                  os.path.join(dawn_libs_path, 'include'), recursive=True)


def fixHeadersForFFIGen(includes_path):
    lib_webgpu = os.path.join(includes_path, 'lib_webgpu.h')
    print('#### FIXING', lib_webgpu)
    fp = open(lib_webgpu, 'rt')
    txt = fp.read()
    fp.close()

    # FFIGen doesn't like unbounded array definitions.
    txt = txt.replace('WGpuCompilationMessage messages[];\n',
                      'WGpuCompilationMessage* messages;\n')

    fp = open(lib_webgpu, 'wt')
    fp.write(txt)
    fp.close()


def build():
    print('#### BUILDING FOR', os_name(), arch_name())
    print('----------------------------')
    with cwd('libwebgpu'):
        print('#### BUILDING libwebgpu in', os.getcwd())
        #buildDawn()

        path = os.getcwd()
        build_path = os.path.join(path, '_build')

        lib_webgpu_url = 'https://github.com/brendan-duncan/wasm_webgpu'
        lib_webgpu_path = os.path.join(build_path, 'lib_webgpu')
        git_clone_and_update_to(lib_webgpu_url, lib_webgpu_path, 'main')

        with cwd(build_path):
            configs = ['Debug']#, 'Release', 'RelWithDebInfo']

            # Copy the lib_webgpu headers to the binding generation folder. This is done before building the DLL
            # so lib_webgpu_dawn.h can be found by lib_webgpu_dart.cpp.
            includes_path = os.path.join('..', 'lib')
            lib_path = os.path.join(lib_webgpu_path, 'lib')
            shutil.copyfile(os.path.join(lib_path, 'lib_webgpu.h'), os.path.join(includes_path, 'lib_webgpu.h'))
            shutil.copyfile(os.path.join(lib_path, 'lib_webgpu_fwd.h'), os.path.join(includes_path, 'lib_webgpu_fwd.h'))
            #shutil.copyfile(os.path.join(lib_path, 'lib_webgpu_dawn.h'),
            #                os.path.join(includes_path, 'lib_webgpu_dawn.h'))

            for config in configs:
                mkdir_p(config)
                with cwd(config):
                    config_cmd = [cmake(), f'-DCMAKE_BUILD_TYPE={config}']
                    if MAC:
                        config_cmd.append('-G Xcode')
                    config_cmd.append(os.path.join('..', '..'))
                    run(config_cmd)
                    run([cmake(), '--build', '.', '--config', config])
                    out_path = os.path.join('..', '..', 'lib', f'{os_name()}-{arch_name()}-{config}')
                    mkdir_p(out_path)
                    if WINDOWS:
                        shutil.copyfile(os.path.join(config, 'webgpu.dll'), os.path.join(out_path, 'webgpu.dll'))
                    else:
                        shutil.copyfile(os.path.join(config, 'libwebgpu.dylib'), os.path.join(out_path, 'libwebgpu.dylib'))

                # Copy the libs into the pub lib folder for distribution

                pub_path = os.path.join('..', '..', 'lib', '_native', f'{os_name()}-{arch_name()}-{config}')
                release_lib_path = os.path.join('..', 'lib', f'{os_name()}-{arch_name()}-{config}')
                mkdir_p(pub_path)
                if WINDOWS:
                    shutil.copyfile(os.path.join(release_lib_path, 'webgpu.dll'), os.path.join(pub_path, 'webgpu.dll'))
                else:
                    shutil.copyfile(os.path.join(release_lib_path, 'libwebgpu.dylib'), os.path.join(pub_path, 'libwebgpu.dylib'))

            # Generate the ffi wrapper with ffigen. The configuration is defined in pubspec.yaml.
            fixHeadersForFFIGen(includes_path)


def main():
    build()
    run(['dart', 'run', 'ffigen'])


if __name__ == '__main__':
    sys.exit(main())
