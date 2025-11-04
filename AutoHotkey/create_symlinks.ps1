
$source = Split-Path -Parent $MyInvocation.MyCommand.Definition
$target = [Environment]::GetFolderPath('Startup')

Get-ChildItem $source -Filter *.ahk | ForEach-Object {
    $link = Join-Path $target $_.Name
    New-Item -ItemType SymbolicLink -Path $link -Target $_.FullName
}
