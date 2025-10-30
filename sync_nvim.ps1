param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('get', 'set')]
    [string]$Command,

    [Parameter(Position = 1)]
    [string]$SourcePath = (Join-Path (Get-Location) 'nvim'),

    [Parameter(Position = 2)]
    [string]$DestinationPath = (Join-Path $env:LOCALAPPDATA 'nvim')
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

function Invoke-SetNvim {
    param([string]$Source, [string]$Destination)
    Remove-DirectorySafe -Path $Destination
    Copy-Directory -Source $Source -Destination $Destination
}

function Invoke-GetNvim {
    param([string]$Source, [string]$Destination)
    Remove-DirectorySafe -Path $Destination
    Copy-Directory -Source $Source -Destination $Destination
}

switch ($Command) {
    'set' { Invoke-SetNvim -Source $SourcePath -Destination $DestinationPath }
    'get' { Invoke-GetNvim -Source $DestinationPath -Destination (Join-Path (Get-Location) 'nvim') }
}
