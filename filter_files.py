#!/usr/bin/env python3
import sys

def filter_files():
    # Read from stdin or file arguments
    if len(sys.argv) > 1:
        # Read from files
        for filename in sys.argv[1:]:
            try:
                with open(filename, 'r') as f:
                    process_lines(f)
            except FileNotFoundError:
                print(f"Error: File '{filename}' not found", file=sys.stderr)
            except Exception as e:
                print(f"Error reading '{filename}': {e}", file=sys.stderr)
    else:
        # Read from stdin
        process_lines(sys.stdin)

def process_lines(file_handle):
    for line in file_handle:
        line = line.strip()
        
        # Skip empty lines
        if not line:
            continue
            
        # Check if the line does NOT end with .usdz or .png (case insensitive)
        if not line.lower().endswith(('.usdz', '.png')):
            print(line)

if __name__ == "__main__":
    filter_files()
