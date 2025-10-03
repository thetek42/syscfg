#!/usr/bin/env python3

import pathlib
import sys

BRIGHTNESS_PATH_0 = '/sys/class/backlight/amdgpu_bl0'
BRIGHTNESS_PATH_1 = '/sys/class/backlight/amdgpu_bl1'

if pathlib.Path(BRIGHTNESS_PATH_0).exists():
    BRIGHTNESS_PATH = BRIGHTNESS_PATH_0
else:
    BRIGHTNESS_PATH = BRIGHTNESS_PATH_1

def show_usage():
    print('usage:')
    print(' - ./brightness [get]      : print current brightness')
    print(' - ./brightness inc        : increase brightness')
    print(' - ./brightness dec        : decrease brightness')
    print(' - ./brightness set <perc> : set to specific value')

def get_brightness_max() -> int:
    with open(BRIGHTNESS_PATH + '/max_brightness', 'r') as f:
        return int(f.read())

def get_brightness() -> int:
    max = get_brightness_max()
    with open(BRIGHTNESS_PATH + '/brightness', 'r') as f:
        return int(round(int(f.read()) / max * 100))

def modify_brightness(step: int):
    current = int(round(get_brightness() / 5) * 5)
    new = min(current + step, 100)
    max = get_brightness_max()
    absolute = int(new / 100 * max)
    with open(BRIGHTNESS_PATH + '/brightness', 'w') as f:
        f.write(str(absolute))

def set_brightness(value: int):
    max = get_brightness_max()
    absolute = int(value / 100 * max)
    with open(BRIGHTNESS_PATH + '/brightness', 'w') as f:
        f.write(str(absolute))

if len(sys.argv) == 1:
    print(get_brightness())
elif len(sys.argv) == 2:
    if sys.argv[1] == 'get':
        print(get_brightness())
    elif sys.argv[1] == 'inc':
        modify_brightness(+5)
    elif sys.argv[1] == 'dec':
        modify_brightness(-5)
    else:
        show_usage()
elif len(sys.argv) == 3 and sys.argv[1] == 'set':
    set_brightness(int(sys.argv[2]))
else:
    show_usage()
