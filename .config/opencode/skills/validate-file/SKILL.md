---
name: validate-file
description: "Validate the format/syntax of a file. E.g. json, yaml, dcm. USE WHEN: validating a file's format or syntax"
---

# Validate File

Scripts live in this skill's own `scripts/` folder. `$env:USERPROFILE\.copilot\skills\validate-file` is the skill root, so the commands below work from any working directory.

* json: `python "$env:USERPROFILE\.copilot\skills\validate-file\scripts\check-json.py" <file>`
* yaml: `python "$env:USERPROFILE\.copilot\skills\validate-file\scripts\check-yaml.py" <file>`
* dcm/dicom: `DicomCli <file> > $null; $LASTEXITCODE` (`0` valid, `4` invalid DICOM, `3` missing). See the `dicomcli` skill.

## Python validators

Both scripts take one or more files, or `-` to read stdin.

```powershell
$vf = "$env:USERPROFILE\.copilot\skills\validate-file\scripts"
python "$vf\check-json.py" a.json b.json
Get-Content a.yaml | python "$vf\check-yaml.py" -
```

Output is one line per file: `<file>: OK` or `<file>: INVALID: <reason> (line N, column M)` followed by the offending line and a caret.

Exit codes: `0` all valid, `1` at least one invalid, `2` usage or I/O error.

## Validating skill/prompt frontmatter

A YAML frontmatter block with an unquoted `description` containing `: ` is invalid and silently stops a skill from loading. To check one, pipe just the frontmatter:

```powershell
$lines = Get-Content SKILL.md
$end = ($lines[1..($lines.Count - 1)] | Select-String '^---$' | Select-Object -First 1).LineNumber
$lines[1..($end - 1)] -join "`n" | python "$env:USERPROFILE\.copilot\skills\validate-file\scripts\check-yaml.py" -
```

## Notes

- YAML validation uses `safe_load_all`, so multi-document files work and custom tags are rejected.
- `check-yaml.py` needs PyYAML (`pip install pyyaml`); `check-json.py` has no dependencies.
- UTF-8 BOM is tolerated in both.
- These validators are read-only. They never modify the file.
