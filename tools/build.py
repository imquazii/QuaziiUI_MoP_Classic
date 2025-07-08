from pathlib import Path
import os
from json import load

raw_import_data: dict = {}
wa_class_list: list = []
wa_non_class_list: list = []

# Get the directory where this script is located
SCRIPT_DIR = Path(__file__).parent

def read_file_with_fallback_encoding(filepath):
    """Try to read a file with different encodings"""
    encodings = ['utf-8', 'utf-8-sig', 'latin-1', 'cp1252']
    
    for encoding in encodings:
        try:
            with open(filepath, "r", encoding=encoding) as f:
                return f.read().strip()
        except UnicodeDecodeError:
            continue
        except Exception as e:
            print(f"Error reading {filepath}: {e}")
            continue
    
    # If all encodings fail, skip this file
    print(f"Warning: Could not read {filepath} with any encoding, skipping...")
    return ""

def get_import_files():
    path = SCRIPT_DIR / "imports"
    for subdir, dirs, files in os.walk(path):
        for file in files:
            if file.endswith(".txt"):
                txt_path = os.path.join(subdir, file)
                txt_base = txt_path.replace("./src/data/json", "")
                txt_base = txt_base.replace("/", "_")
                txt_base = txt_base.replace("\\", "_")[1:]
                txt_split = txt_base.split(".")[0][1:]
                txt_split = (
                    txt_base.replace("tools_", "")
                    .replace("imports_", "")
                    .replace("addons_", "")
                    .replace("weakauras_class_", "")
                    .replace("elvui_", "")
                    .replace("weakauras_non-class_", "")
                )[1:][:-4]
                
                # Use the new function to read files with fallback encoding
                file_content = read_file_with_fallback_encoding(txt_path)
                if not file_content:
                    continue
                
                if "routes" in txt_path:
                    if "PUG" in txt_path:
                        mdt_w_routes_list.append(
                            file_content.join(('"', '"'))
                        )
                    elif "Adv" in txt_path:
                        mdt_adv_routes_list.append(
                            file_content.join(('"', '"'))
                        )
                elif "weakauras" in txt_path:
                    if "class" in txt_path:
                        wa_class_list.append(
                            file_content.join(('"', '"'))
                        )
                    elif "utility" in txt_path:
                        wa_non_class_list.append(
                            file_content.join(('"', '"'))
                        )
                else:
                    raw_import_data[txt_split] = file_content


def get_template():
    path = SCRIPT_DIR / "imports_template.lua"
    with path.open(encoding='utf-8') as template:
        return template.read()


def write_template(input):
    path = SCRIPT_DIR.parent / "QuaziiUI_MoP_Classic" / "imports.lua"
    with open(path, "w", encoding='utf-8') as template:
        template.write(input)


def process_temple():
    template = get_template()
    wa_class_string = ",\n            ".join(wa_class_list)
    wa_non_class_string = ",\n            ".join(wa_non_class_list)

    template = template.replace('"{CLASS_WA}"', wa_class_string)
    template = template.replace('"{NON_CLASS_WA}"', wa_non_class_string)

    for k, v in raw_import_data.items():
        replace_string = "{" + k + "}"
        value_string = v
        template = template.replace(replace_string, value_string)
    write_template(template)


get_import_files()

process_temple()
