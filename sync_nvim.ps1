param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('get', 'set')]
    [string]$Command,
    [Parameter(Position = 1)]
    [string]$SourcePath = (Join-Path (Get-Location) 'nvim'),
    [Parameter(Position = 2)]
    [string]$DestinationPath = (Join-Path $env:LOCALAPPDATA 'nvim'),
    [Parameter()]
    [switch]$SkipDiff
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Remove-DirectorySafe {
    param([string]$Path)
    if (Test-Path $Path) {
        Remove-Item -Recurse -Force -Path $Path
    }
}

function Copy-Directory {
    param(
        [string]$Source,
        [string]$Destination
    )
    if (-not (Test-Path $Source)) { throw "Source path not found: $Source" }
    New-Item -ItemType Directory -Force -Path (Split-Path $Destination) | Out-Null
    Copy-Item -Recurse -Force -Path $Source -Destination $Destination
}

function Test-GitAvailable {
    try {
        $null = Get-Command git -ErrorAction Stop
        return $true
    }
    catch {
        return $false
    }
}

function Show-ConfigDiff {
    param(
        [string]$BackupPath,
        [string]$NewPath
    )

    if (-not (Test-GitAvailable)) {
        Write-Host "Git is not available. Skipping diff." -ForegroundColor Yellow
        return
    }

    Write-Host "`n========================================" -ForegroundColor Magenta
    Write-Host "Configuration Changes (git diff)" -ForegroundColor Magenta
    Write-Host "========================================" -ForegroundColor Magenta
    Write-Host "Old: $BackupPath" -ForegroundColor Cyan
    Write-Host "New: $NewPath" -ForegroundColor Green
    Write-Host ""

    try {
        # Suppress line ending warnings by setting core.safecrlf to false temporarily
        $originalSafeCrlf = git config --global core.safecrlf 2>$null
        git config --global core.safecrlf false 2>&1 | Out-Null

        # Use git diff with --no-index to compare directories
        # Redirect stderr to filter out CRLF warnings
        $diffOutput = git diff --no-index --color=always --stat $BackupPath $NewPath 2>&1 |
            Where-Object { $_ -notmatch 'LF will be replaced by CRLF|CRLF will be replaced by LF' }

        if ($LASTEXITCODE -eq 0) {
            Write-Host "No differences found between backup and new configuration." -ForegroundColor Green
        }
        else {
            # Show the diff output
            $diffOutput | ForEach-Object { Write-Host $_ }

            Write-Host "`n----------------------------------------" -ForegroundColor Magenta
            Write-Host "Detailed diff:" -ForegroundColor Magenta
            Write-Host "----------------------------------------`n" -ForegroundColor Magenta

            # Show detailed diff, filtering out CRLF warnings
            git diff --no-index --color=always $BackupPath $NewPath 2>&1 |
                Where-Object { $_ -notmatch 'LF will be replaced by CRLF|CRLF will be replaced by LF' } |
                ForEach-Object { Write-Host $_ }
        }

        # Restore original safecrlf setting
        if ($null -ne $originalSafeCrlf -and $originalSafeCrlf -ne '') {
            git config --global core.safecrlf $originalSafeCrlf 2>&1 | Out-Null
        }
        else {
            git config --global --unset core.safecrlf 2>&1 | Out-Null
        }
    }
    catch {
        Write-Host "Error generating diff: $_" -ForegroundColor Red
    }

    Write-Host "`n========================================`n" -ForegroundColor Magenta
}

function Backup-ExistingConfig {
    param([string]$Path)

    if (-not (Test-Path $Path)) {
        return $null
    }

    $timestamp = Get-Date -Format 'yyyyMMdd_HHmmss'
    $parentPath = Split-Path $Path -Parent
    $dirName = Split-Path $Path -Leaf
    $backupPath = Join-Path $parentPath "$dirName.backup_$timestamp"

    Copy-Directory -Source $Path -Destination $backupPath
    Write-Host "Backup created: $backupPath" -ForegroundColor Cyan

    return $backupPath
}

function Invoke-SetNvim {
    param(
        [string]$Source,
        [string]$Destination,
        [bool]$ShowDiff
    )

    $backupPath = Backup-ExistingConfig -Path $Destination

    Remove-DirectorySafe -Path $Destination
    Copy-Directory -Source $Source -Destination $Destination

    Write-Host "Configuration deployed successfully to: $Destination" -ForegroundColor Green
    if ($backupPath) {
        Write-Host "Previous configuration backed up to: $backupPath" -ForegroundColor Yellow

        if ($ShowDiff) {
            Show-ConfigDiff -BackupPath $backupPath -NewPath $Destination
        }
    }
}

function Invoke-GetNvim {
    param([string]$Source, [string]$Destination)
    Remove-DirectorySafe -Path $Destination
    Copy-Directory -Source $Source -Destination $Destination
    Write-Host "Configuration retrieved successfully to: $Destination" -ForegroundColor Green
}

switch ($Command) {
    'set' { Invoke-SetNvim -Source $SourcePath -Destination $DestinationPath -ShowDiff (-not $SkipDiff) }
    'get' { Invoke-GetNvim -Source $DestinationPath -Destination (Join-Path (Get-Location) 'nvim') }
}
