import os

def count_lines_in_file(file_path):
    """Count the number of non-empty lines in a file."""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            # Skip empty lines and comments (optional)
            lines = [line.strip() for line in file if line.strip() and not line.strip().startswith('//')]
            return len(lines)
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
        return 0

def count_lines_in_directory(directory):
    """Count total lines in all .dart files in the given directory."""
    total_lines = 0

    # Walk through the directory
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):  # Only count Dart files
                file_path = os.path.join(root, file)
                lines = count_lines_in_file(file_path)
                print(f"{file_path}: {lines} lines")
                total_lines += lines

    return total_lines

# Specify the path to your Flutter app's lib/ directory
flutter_lib_path = "/Users/macos/Desktop/new projects/laravel_ecommerce/lib"

# Calculate total lines
total = count_lines_in_directory(flutter_lib_path)
print(f"\nTotal lines of code in {flutter_lib_path}: {total}")

# python3 s.py