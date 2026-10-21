"""Validate the syntax of one or more JSON files.

Exit codes: 0 = all valid, 1 = at least one invalid, 2 = usage or I/O error.
"""

import json
import sys


def read_source(path):
    if path == "-":
        return sys.stdin.read()
    with open(path, "r", encoding="utf-8-sig") as handle:
        return handle.read()


def format_context(text, line, column):
    """Return the offending source line plus a caret pointing at the column."""
    lines = text.splitlines()
    if not 1 <= line <= len(lines):
        return []

    source = lines[line - 1].replace("\t", " ")
    caret = " " * max(column - 1, 0) + "^"
    return [f"  {source}", f"  {caret}"]


def check(path):
    try:
        text = read_source(path)
    except OSError as err:
        print(f"{path}: ERROR: {err.strerror or err}")
        return 2
    except UnicodeDecodeError as err:
        print(f"{path}: INVALID: not valid UTF-8: {err}")
        return 1

    try:
        json.loads(text)
    except json.JSONDecodeError as err:
        print(f"{path}: INVALID: {err.msg} (line {err.lineno}, column {err.colno})")
        for line in format_context(text, err.lineno, err.colno):
            print(line)
        return 1

    print(f"{path}: OK")
    return 0


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        print("Usage: python check-json.py <file> [file ...]")
        print("       python check-json.py -            (read from stdin)")
        return 2 if not argv else 0

    return max(check(path) for path in argv)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
