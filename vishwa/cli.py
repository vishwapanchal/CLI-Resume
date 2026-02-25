import argparse
import base64
from .matrix import matrix_rain
from .renderer import enable_windows_ansi, clear, print_centered
from .resume_data import get_resume_lines
from .pdf_data import PDF_BASE64

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--loop", action="store_true")
    parser.add_argument("--fun", action="store_true")
    parser.add_argument("--theme", choices=["hacker", "rainbow", "minimal"], default="rainbow")
    args = parser.parse_args()

    enable_windows_ansi()

    if args.loop or args.fun:
        try:
            matrix_rain(duration=None, theme=args.theme)
        except KeyboardInterrupt:
            print("\nStopped.")
        return

    matrix_rain(duration=2, theme=args.theme)
    clear()

    print_centered(get_resume_lines())
    input("\nPress Enter to continue...")

    choice = input("\nWould you like to materialize the full PDF version? (y/n): ").strip().lower()

    if choice == "y":
        with open("Vishwa_Panchal_Resume.pdf", "wb") as f:
            f.write(base64.b64decode(PDF_BASE64))
        print("\nResume materialized successfully.")