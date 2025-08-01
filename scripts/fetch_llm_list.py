import requests
from pathlib import Path

# The direct URL to the raw text file on GitHub
FILE_URL = "https://raw.githubusercontent.com/google/adk-python/main/llms-full.txt"

# Where to save the file in your repository
OUTPUT_DIR = Path(__file__).parent.parent / "docs"
OUTPUT_FILE = OUTPUT_DIR / "llms-full.txt"

def fetch_file():
    """Fetches the latest version of the llms-full.txt file."""
    print(f"Fetching file from {FILE_URL}")
    try:
        response = requests.get(FILE_URL)
        response.raise_for_status()

        OUTPUT_DIR.mkdir(exist_ok=True)

        OUTPUT_FILE.write_text(response.text, encoding='utf-8')
        print(f"Successfully saved file to {OUTPUT_FILE}")

    except requests.exceptions.RequestException as e:
        print(f"Error fetching file: {e}")
        exit(1)

if __name__ == "__main__":
    fetch_file()
