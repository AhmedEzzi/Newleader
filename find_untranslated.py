import os
import re
import json

# Paths
json_file_path = "assets/i18n/en.json"
lib_folder_path = "lib"

# Read the en.json file
try:
    with open(json_file_path, 'r', encoding='utf-8') as f:
        translation_data = json.load(f)
except FileNotFoundError:
    print(f"Error: {json_file_path} not found.")
    exit(1)
except json.JSONDecodeError:
    print(f"Error: {json_file_path} is not a valid JSON file.")
    exit(1)

# Get all keys from en.json (flatten nested keys if any)
def flatten_keys(data, parent_key=''):
    keys = []
    for key, value in data.items():
        new_key = f"{parent_key}.{key}" if parent_key else key
        keys.append(new_key)
        if isinstance(value, dict):
            keys.extend(flatten_keys(value, new_key))
    return keys

translation_keys = set(flatten_keys(translation_data))

# Regex to match strings in the format 'some_key'.tr(context)
pattern = r"'([^']+)'\.tr\(context\)"

# Store untranslated keys
untranslated_keys = set()

# Scan all .dart files in the lib folder
for root, _, files in os.walk(lib_folder_path):
    for file in files:
        if file.endswith(".dart"):
            file_path = os.path.join(root, file)
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                    # Find all matches
                    matches = re.findall(pattern, content)
                    for match in matches:
                        # Check if the key is in the translation file
                        if match not in translation_keys:
                            untranslated_keys.add(match)
            except Exception as e:
                print(f"Error reading {file_path}: {e}")

# Output results
if untranslated_keys:
    print("Untranslated keys found:")
    for key in sorted(untranslated_keys):
        print(f"- {key}")
else:
    print("No untranslated keys found.")