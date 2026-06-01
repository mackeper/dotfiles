Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$sourceSkills = 'C:\Users\marost\AppData\Roaming\Code\User\skills'
$targetSkills = Join-Path $PSScriptRoot 'skills'

if (-not (Test-Path -LiteralPath $sourceSkills -PathType Container)) {
	throw "Source skills folder not found: $sourceSkills"
}

if (-not (Test-Path -LiteralPath $targetSkills -PathType Container)) {
	New-Item -ItemType Directory -Path $targetSkills | Out-Null
}

$skills = [object[]](Get-ChildItem -LiteralPath $sourceSkills -Directory)

foreach ($skill in $skills) {
	$destination = Join-Path $targetSkills $skill.Name

	if (Test-Path -LiteralPath $destination) {
		Remove-Item -LiteralPath $destination -Recurse -Force
	}

	Copy-Item -LiteralPath $skill.FullName -Destination $destination -Recurse -Force
	Write-Host "Pulled skill: $($skill.Name)"
}

Write-Host "Pulled $($skills.Count) skill(s) from VS Code to opencode."
