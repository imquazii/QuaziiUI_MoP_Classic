from pathlib import Path
import os
from json import load

raw_import_data = {}


def get_import_files():
    path = "./tools/imports"
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
                with open(txt_path, "r", encoding="utf-8") as import_file:
                    raw_import_data[txt_split] = import_file.read().strip()


def get_template():
    path: Path = Path.cwd().joinpath("tools/imports_template.lua")
    with path.open() as template:
        return template.read()


def write_template(input):
    path: Path = Path.cwd().joinpath("tools/imports.lua")
    with open(path, "w") as template:
        template.write(input)


def process_temple():
    template = get_template()
    for k, v in raw_import_data.items():
        replace_string = "{" + k + "}"
        value_string = v
        template = template.replace(replace_string, value_string)
    write_template(template)


get_import_files()

process_temple()
