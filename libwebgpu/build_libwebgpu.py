import build_dawn
import os
import shutil
import sys


def main():
    # build_dawn.main()
    with build_dawn.cwd('build'):
        configs = ['Debug', 'Release']
        for config in configs:
            build_dawn.mkdir_p(config)
            with build_dawn.cwd(config):
                build_dawn.run(['cmake', f'-DCMAKE_BUILD_TYPE={config}', os.path.join('..', '..')])
                build_dawn.run(['cmake', '--build', '.', '--config', config])
                out_path = os.path.join('..', '..', 'libs', f'{build_dawn.os_name()}-{config}')
                build_dawn.mkdir_p(out_path)
                shutil.copyfile(os.path.join(config, 'webgpu.dll'), os.path.join(out_path, 'webgpu.dll'))


if __name__ == '__main__':
    sys.exit(main())
