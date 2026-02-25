import sys
import os
import time
import shutil

RESET = "\033[0m"
GREEN = "\033[92m"
CYAN = "\033[96m"
BRIGHT = "\033[32;1m"
CLEAR = "\033[2J\033[H"

def enable_windows_ansi():
    if os.name == "nt":
        try:
            import ctypes
            kernel32 = ctypes.windll.kernel32
            handle = kernel32.GetStdHandle(-11)
            mode = ctypes.c_uint32()
            if kernel32.GetConsoleMode(handle, ctypes.byref(mode)):
                kernel32.SetConsoleMode(handle, mode.value | 0x0004)
        except:
            pass

def clear():
    sys.stdout.write(CLEAR)
    sys.stdout.flush()

def print_centered(lines):
    cols = shutil.get_terminal_size().columns
    for line in lines:
        if line.isupper():
            print(BRIGHT + line.center(cols) + RESET)
        elif line.startswith("-"):
            print(CYAN + line.center(cols) + RESET)
        else:
            print(GREEN + line.center(cols) + RESET)
        time.sleep(0.08)
