import sys
import libwebgpu


def build():
    #libwebgpu.build()
    libwebgpu.run(['dart', 'run', 'ffigen'])


if __name__ == '__main__':
    sys.exit(build())
