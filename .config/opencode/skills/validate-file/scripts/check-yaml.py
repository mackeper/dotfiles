"""Validate the syntax of one or more YAML files.

Handles multi-document files. Uses safe_load, so custom tags are rejected.

Exit codes: 0 = all valid, 1 = at least one invalid, 2 = usage or I/O error.
"""

import sys

try:
    import yaml
except ImportError:
    print("ERROR: PyYAML is not installed. Install it with: pip install pyyaml")
    sys.exit(2)


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


def describe(err):
    parts = [part for part in (err.context, err.problem) if part]
    return ": ".join(parts) if parts else str(err)


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
        documents = sum(1 for _ in yaml.safe_load_all(text))
    except yaml.MarkedYAMLError as err:
        mark = err.problem_mark or err.context_mark
        if mark is None:
            print(f"{path}: INVALID: {describe(err)}")
            return 1

        line, column = mark.line + 1, mark.column + 1
        print(f"{path}: INVALID: {describe(err)} (line {line}, column {column})")
        for entry in format_context(text, line, column):
            print(entry)
        return 1
    except yaml.YAMLError as err:
        print(f"{path}: INVALID: {err}")
        return 1

    suffix = " (empty)" if documents == 0 else f" ({documents} document(s))"
    print(f"{path}: OK{suffix}")
    return 0


def main(argv):
    if not argv or argv[0] in ("-h", "--help"):
        print("Usage: python check-yaml.py <file> [file ...]")
        print("       python check-yaml.py -            (read from stdin)")
        return 2 if not argv else 0

    return max(check(path) for path in argv)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
