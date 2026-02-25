import random
import time
import shutil
from .renderer import clear

COLORS = [
    "\033[92m",  # green
    "\033[96m",  # cyan
    "\033[95m",  # magenta
    "\033[93m",  # yellow
    "\033[94m",  # blue
]

RESET = "\033[0m"
CHARS = "01ABCDEFGHIJKLMNOPQRSTUVWXYZ@#%&*"

def matrix_rain(duration=None, theme="rainbow"):
    cols, rows = shutil.get_terminal_size()
    
    while True:
        clear()
        for _ in range(rows - 1):
            line = ""
            for _ in range(cols):
                char = random.choice(CHARS)
                if theme == "hacker":
                    color = "\033[92m"
                elif theme == "minimal":
                    color = ""
                else:
                    color = random.choice(COLORS)
                line += color + char + RESET
            print(line)
        time.sleep(0.05)
        
        if duration:
            duration -= 0.05
            if duration <= 0:
                break