function Remove-Alias ([string] $AliasName)
{
    while (Test-Path Alias:$AliasName)
    {
        Remove-Item Alias:$AliasName -Force 2> $null
    }
}

function Test-Command($cmdname)
{
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

Remove-Alias cp
Remove-Alias mv
Remove-Alias rm
Remove-Alias cat
Remove-Alias ls
Remove-Alias wget

Set-Alias cp Copy-Item
Set-Alias mv Move-Item
Set-Alias rm Remove-Item
Set-Alias cat Get-Content

function ls([string]$path = ".")
{ 
    if (Test-Command("eza"))
    { eza --icons $path
    } else
    { Get-ChildItem -Exclude ".*" $path | Format-Wide -AutoSize -ErrorAction SilentlyContinue
    }
}

function ll([string]$path = ".")
{
    if (Test-Command("eza"))
    { eza --icons -la $path
    } else
    { Get-ChildItem $path
    }
}

function lt([string]$path = ".")
{
    if (Test-Command("eza"))
    { eza --icons --tree --level 2 $path
    } else
    { tree $path
    }
}

function wget($url)
{
    Invoke-WebRequest -Uri $url -OutFile (Split-Path $url -Leaf)
}

function unzip($zipFile, $destination = ".")
{
    Expand-Archive -Path $zipFile -DestinationPath $destination
}

function which($command)
{
    (Get-Command $command -ErrorAction SilentlyContinue).Source
}

function touch($path)
{
    if (-not (Test-Path $path))
    { New-Item -Path $path -ItemType File | Out-Null 
    } else
    { Get-Item $path | Set-ItemProperty -Name LastWriteTime -Value (Get-Date) 
    }
}

function head($file, $lines = 10)
{
    Get-Content $file -Head $lines
}

function tail($file, $lines = 10)
{
    Get-Content $file -Tail $lines
}

function grep($pattern, $file)
{
    Select-String -Pattern $pattern -Path $file
}

function find($path, $name)
{
    Get-ChildItem -Path $path -Recurse -Filter $name
}

function chmod($permissions, $path)
{
    $attributes = [System.IO.FileAttributes]::Normal
    if ($permissions -match "r")
    { $attributes = $attributes -bor [System.IO.FileAttributes]::ReadOnly 
    }
    if ($permissions -match "w")
    { $attributes = $attributes -bxor [System.IO.FileAttributes]::ReadOnly 
    }
    if ($permissions -match "x")
    { $attributes = $attributes -bor [System.IO.FileAttributes]::Archive 
    }
    (Get-Item $path).Attributes = $attributes
}

function df
{
    Get-PSDrive -PSProvider FileSystem
}

function du($path)
{
    Get-ChildItem -Path $path -Recurse | Measure-Object -Property Length -Sum | Select-Object @{Name="TotalSizeMB";Expression={[math]::Round($_.Sum / 1MB, 2)}}
}

function ps
{
    Get-Process
}

function kill($pid)
{
    Stop-Process -Id $pid
}

function top
{
    Get-Process | Sort-Object -Property CPU -Descending | Select-Object -First 10
}

function date
{
    Get-Date
}

function history
{
    Get-History
}

function alias
{
    Get-Alias
}
