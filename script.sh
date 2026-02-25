#!/usr/bin/env bash
set -e

PROJECT="vishwa"
PACKAGE="vishwa"
PDF_FILE="vishwapanchal.pdf"


if [ ! -f "$PDF_FILE" ]; then
  echo "ERROR: $PDF_FILE not found."
  echo "Place your resume PDF here and rename it to vishwapanchal.pdf"
  exit 1
fi

echo "Encoding PDF..."
BASE64_PDF=$(base64 -w 0 "$PDF_FILE")

echo "Creating project structure..."
mkdir -p $PACKAGE

#################################
# __init__.py
#################################
cat > $PACKAGE/__init__.py <<EOF
__version__ = "1.0.0"
EOF

#################################
# resume_data.py
#################################
cat > $PACKAGE/resume_data.py <<'EOF'
def get_resume_lines():
    return [
        "VISHWA PANCHAL",
        "+91 8277665467 | thevishwapanchal@gmail.com | LinkedIn | GitHub",
        "",
        "PROFESSIONAL SUMMARY",
        "DevOps Engineer and Backend Developer specializing in cloud infrastructure, CI/CD automation,",
        "microservices architecture, and AWS solutions.",
        "",
        "TECHNICAL SKILLS",
        "AWS, Docker, Kubernetes, Terraform, Jenkins, GitHub Actions",
        "Python (Advanced), FastAPI, REST APIs",
        "PostgreSQL, MongoDB, Redis",
        "",
        "EXPERIENCE",
        "R&D Intern – Cloud Engineering & DevOps",
        "Automated Linux systems, implemented Docker/Kubernetes deployments,",
        "built CI/CD pipelines reducing deployment time by 70%.",
        "",
        "PROJECTS",
        "Cloud-Hosted EL Management Platform",
        "Gram Sahayak: Digital Governance System",
        "",
        "CONTACT",
        "GitHub: github.com/yourusername",
        "Email: thevishwapanchal@gmail.com",
    ]
EOF

#################################
# pdf_data.py
#################################
cat > $PACKAGE/pdf_data.py <<EOF
PDF_BASE64 = "$BASE64_PDF"
EOF

#################################
# renderer.py
#################################
cat > $PACKAGE/renderer.py <<'EOF'
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
EOF

#################################
# matrix.py
#################################
cat > $PACKAGE/matrix.py <<'EOF'
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
EOF

#################################
# cli.py
#################################
cat > $PACKAGE/cli.py <<'EOF'
import base64
from .matrix import matrix_rain
from .renderer import enable_windows_ansi, clear, print_centered
from .resume_data import get_resume_lines
from .pdf_data import PDF_BASE64

def main():
    enable_windows_ansi()
    matrix_rain(2)
    clear()

    print_centered(get_resume_lines())
    input("\nPress Enter to continue...")

    choice = input("\nWould you like to materialize the full PDF version? (y/n): ").strip().lower()

    if choice == "y":
        with open("Vishwa_Panchal_Resume.pdf", "wb") as f:
            f.write(base64.b64decode(PDF_BASE64))
        print("\nResume materialized successfully.")
    else:
        print("\nExit initiated.")
EOF

#################################
# pyproject.toml
#################################
cat > pyproject.toml <<EOF
[build-system]
requires = ["setuptools", "wheel"]
build-backend = "setuptools.build_meta"

[project]
name = "$PROJECT"
version = "1.0.0"
description = "Animated hacker-style resume CLI."
authors = [{name="Vishwa Panchal"}]
requires-python = ">=3.8"

[project.scripts]
vishwa = "$PACKAGE.cli:main"
EOF

echo "Creating virtual environment..."
python -m venv .venv
source .venv/Scripts/activate || source .venv/bin/activate

echo "Installing build..."
python -m pip install build

echo "Building package..."
python -m build

echo "Installing locally..."
pip install .

echo "DONE."
echo "Activate venv and run:"
echo "source .venv/Scripts/activate && vishwa"