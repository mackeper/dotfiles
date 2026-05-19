param(
	[switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Main {
	$sourceSkills = 'C:\Users\marost\AppData\Roaming\Code\User\skills'
	$targetSkills = Join-Path $PSScriptRoot 'skills'

	if (-not (Test-Path -LiteralPath $sourceSkills -PathType Container)) {
		throw "Source skills folder not found: $sourceSkills"
	}

	if (-not (Test-Path -LiteralPath $targetSkills -PathType Container)) {
		New-Item -ItemType Directory -Path $targetSkills | Out-Null
	}

	$excludePatterns = @('marost', 'dicom', 'dcm', 'raysearch', 'raycare', 'txi', 'tfs', 'workitem', 'work-item')
	$skills = @(Get-ChildItem -LiteralPath $sourceSkills -Directory | Where-Object {
		$content = Get-ChildItem -LiteralPath $_.FullName -File -Recurse | Get-Content -Raw -ErrorAction SilentlyContinue
		$joined = $content -join "`n"
		-not ($excludePatterns | Where-Object { $joined -match [regex]::Escape($_) })
	})

	foreach ($skill in $skills) {
		$destination = Join-Path $targetSkills $skill.Name

		if ($DryRun) {
			Write-Host "[DryRun] Would pull skill: $($skill.Name)"
			continue
		}

		if (Test-Path -LiteralPath $destination) {
			Remove-Item -LiteralPath $destination -Recurse -Force
		}

		Copy-Item -LiteralPath $skill.FullName -Destination $destination -Recurse -Force
		Write-Host "Pulled skill: $($skill.Name)"
	}

	Write-Host "Pulled $($skills.Count) skill(s) from VS Code to opencode."
}

Main
