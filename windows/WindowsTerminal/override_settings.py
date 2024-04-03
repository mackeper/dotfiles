#!/usr/bin/python3

# merge two json files
import json
from pathlib import Path


def deep_update(dict1, dict2):
    for key, value in dict2.items():
        if key in dict1 and isinstance(dict1[key], dict) and isinstance(value, dict):
            deep_update(dict1[key], value)
        else:
            dict1[key] = value


def merge_json(json1, json2):
    with open(json1, "r") as f:
        data1 = json.load(f)
    with open(json2, "r") as f:
        data2 = json.load(f)
    deep_update(data1, data2)
    with open(json1, "w") as f:
        json.dump(data1, f, indent=4)


# in the subdirectory "themes" of the script directory
# multiple json files exists that should be added to the settings.json file
# in the "schemes" key
def add_theme(settings_file, theme_file):
    print(f"Adding theme {theme_file}")
    with open(theme_file, "r") as f:
        theme = json.load(f)
    with open(settings_file, "r") as f:
        settings = json.load(f)
    if "schemes" not in settings:
        settings["schemes"] = {}
    settings["schemes"].append(theme)
    with open(settings_file, "w") as f:
        json.dump(settings, f, indent=4)


def add_themes(settings_file, themes_dir):
    for theme_file in themes_dir.glob("*.json"):
        add_theme(settings_file, theme_file)


if __name__ == "__main__":
    # windows terminal settings file
    # C:\Users\{USERNAME}\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState

    # if in wsl
    # try:
    #     if Path("/mnt/c").exists():
    #         print("This script is for Windows only")
    #         exit(1)
    # finally:
    #     pass
    print("This script is for Windows only")

    settings_file = (
        Path.home()
        / "AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json"
    )
    merge_json(settings_file, Path(__file__).parent / "settings.bak.json")
    add_themes(settings_file, Path(__file__).parent / "themes")
