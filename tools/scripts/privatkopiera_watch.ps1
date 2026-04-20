function main
{
    $lastClipboard = ""
    $kidsDirectory = "Kids"
    $regularDirectory = "Regular"

    $kidsShows = @(
        "Greta Gris",
        "Bluey",
        "PAW Patrol",
        "Spidey och hans fantastiska vänner"
        "Pippi Långstrump"
        "Pettson och Findus"
    )

    while ($true)
    {
        $clipboard = Get-Clipboard -Raw

        if ($clipboard -ne $lastClipboard -and $clipboard.StartsWith("ffmpeg") -eq $true)
        {
            $lastClipboard = $clipboard
            $clipboard | Out-File -Append -FilePath "./privatkopiera_watch.log" -Encoding utf8

            # TODO: handle not matching
            $foundFilename = ($clipboard -match '"([^-]+) - ([^"]+).mp4"')
            $showName = $matches[1]
            $episodeName = $matches[2]

            $directory = $kidsShows -contains $showName ? $kidsDirectory : $regularDirectory
            $destination = Join-Path "." $directory $showName
            $outputPath = Join-Path $destination "$showName - $episodeName.mp4"
            $srtOutputPath = Join-Path $destination "$showName - $episodeName.srt"
            mkdir -Force $destination | Out-Null
            Set-Location $destination | Out-Null

            # Get video
            if (Test-Path $outputPath)
            {
                write-host "Skipping, file already exists: $outputPath"
            } else
            {
                Invoke-Expression -Command "$clipboard &" | Out-Null
            }

            # Get subtitles
            if (Test-Path $srtOutputPath)
            {
                write-host "Skipping, file already exists: $srtOutputPath"
            } else
            {
                $srtClipboard = $clipboard -replace ".mp4", ".srt"
                Invoke-Expression -Command "$srtClipboard &" | Out-Null
            }

            Set-Location - | Out-Null

            write-host $outputPath
        }

        $nJobs = $(Get-Job -State Running).Count
        Write-Progress -Activity "Watching clipboard" -Status "Waiting for clipboard change. Current Jobs: $nJobs" -PercentComplete 0
        Start-Sleep -Seconds 2
    }
}

main
