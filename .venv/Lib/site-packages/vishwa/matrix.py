import random
import time
import shutil
from .renderer import clear, GREEN, RESET

CHARS = "01ABCDEFGHIJKLMNOPQRSTUVWXYZ@#%&*"

def matrix_rain(duration=2):
    cols, rows = shutil.get_terminal_size()
    end = time.time() + duration
    while time.time() < end:
        clear()
        for _ in range(rows - 1):
            print(GREEN + "".join(random.choice(CHARS) for _ in range(cols)) + RESET)
        time.sleep(0.05)
