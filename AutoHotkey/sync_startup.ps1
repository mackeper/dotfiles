param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('get', 'set')]
    [string]$Command,

    [Parameter(Position = 1)]
    [string]$SourcePath = (Get-Location).Path,

    [Parameter(Position = 2)]
    [string]$DestinationPath = ([Environment]::GetFolderPath('Startup'))
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Copy-AhkFiles {
    param(
        [Parameter(Mandatory = $true)][string]$From,
        [Parameter(Mandatory = $true)][string]$To,
        [switch]$ExcludeRaysearch
    )

    if (-not (Test-Path $From)) { throw "Source path not found: $From" }
    if (-not (Test-Path $To)) { New-Item -ItemType Directory -Path $To | Out-Null }

    $files = Get-ChildItem -Path $From -Filter '*.ahk' -File -Recurse
    if ($ExcludeRaysearch) {
        $files = $files | Where-Object { $_.Name -ne 'raysearch.ahk' }
    }

    foreach ($file in $files) {
        Copy-Item -Path $file.FullName -Destination $To -Force
    }
}

function Invoke-SetStartup {
    param([string]$Source, [string]$Destination)
    Copy-AhkFiles -From $Source -To $Destination
}

function Invoke-GetStartup {
    param([string]$Source, [string]$Destination)
    Copy-AhkFiles -From $Source -To $Destination -ExcludeRaysearch
}

switch ($Command) {
    'set' { Invoke-SetStartup -Source $SourcePath -Destination $DestinationPath }
    'get' { Invoke-GetStartup -Source $DestinationPath -Destination $SourcePath }
}
