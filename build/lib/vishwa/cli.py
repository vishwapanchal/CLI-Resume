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
