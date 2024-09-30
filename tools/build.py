from pathlib import Path
import json


def getImportsPath() -> Path:
    """

    returns: pathlib.WindowsPath -> File path to imports folder.
    """
    base_dir: Path = Path.cwd()
    while not base_dir.as_posix().endswith("QuaziiUI"):
        base_dir: Path = base_dir.parents[0]
    imports_dir: Path = base_dir.joinpath("imports")
    return imports_dir


def getChecksums(base_dir: Path) -> dict:
    with open(base_dir.joinpath("checksums.json")) as f:
        checksums = json.load(f)
    return checksums


imports_dir: Path = getImportsPath()
checksums: dict = getChecksums(imports_dir)
addons = checksums["addons"]
weakauras = checksums["weakauras"]

print(addons)
print(weakauras)
