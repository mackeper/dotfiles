param(
    [Parameter(Mandatory)][string]$Path
)

$bytes = [System.IO.File]::ReadAllBytes((Resolve-Path $Path))
$content = [System.Text.Encoding]::Latin1.GetString($bytes)

# --- Determine page count and page boundaries ---
$pageCount = if ($content -match '/Count\s+(\d+)') { [int]$Matches[1] } else { 0 }

# --- Decompress streams ---
$streamMatches = [regex]::Matches($content, 'stream\r?\n(.+?)\r?\nendstream', [System.Text.RegularExpressions.RegexOptions]::Singleline)

$noisePatterns = @(
    '^en-US$', '^[a-f0-9]{16,}$', '^https?://', '^Adobe$', '^UCS$',
    '^Microsoft$', '^\s*$', '^\W+$', '^.{1,2}$',
    '\\x[0-9a-fA-F]', '[\x00-\x08\x0B\x0C\x0E-\x1F]',  # control chars
    '^[^a-zA-Z]*$',                                        # no letters at all
    'SubCA', 'crl\.microsoft', 'pki/certs', '\*�H',       # certificate noise
    'Legal_Policy', 'CPS/default', 'MicRooCerAut',
    'Layout Logic Software', 'Code Signing',
    '^\W*\+\W*$', '^\d+$',                                # just symbols/numbers
    '[\x80-\xFF]{4,}'                                      # runs of high bytes (binary)
)

function Test-Noise([string]$text) {
    foreach ($p in $noisePatterns) {
        if ($text -match $p) { return $true }
    }
    # Mostly non-printable / control chars
    $printable = ($text.ToCharArray() | Where-Object { [int]$_ -ge 32 -and [int]$_ -le 126 }).Count
    if ($text.Length -gt 0 -and ($printable / $text.Length) -lt 0.7) { return $true }
    # Too short after trimming to be meaningful
    $trimmed = $text.Trim()
    if ($trimmed.Length -lt 3) { return $true }
    # Ratio of letters to total length too low (likely binary/font data)
    $letters = ($text.ToCharArray() | Where-Object { $_ -match '[a-zA-Z ]' }).Count
    if ($text.Length -gt 10 -and ($letters / $text.Length) -lt 0.4) { return $true }
    return $false
}

function ConvertFrom-HexString([string]$hex) {
    $hex = $hex -replace '\s', ''
    if ($hex.Length % 2 -ne 0) { $hex += '0' }
    $chars = for ($i = 0; $i -lt $hex.Length; $i += 2) {
        [char][Convert]::ToInt32($hex.Substring($i, 2), 16)
    }
    return -join $chars
}

function Get-StreamText([byte[]]$raw) {
    # Try deflate (skip 2-byte zlib header)
    try {
        $ms = New-Object System.IO.MemoryStream(,$raw)
        $null = $ms.ReadByte()
        $null = $ms.ReadByte()
        $ds = New-Object System.IO.Compression.DeflateStream($ms, [System.IO.Compression.CompressionMode]::Decompress)
        $sr = New-Object System.IO.StreamReader($ds)
        $text = $sr.ReadToEnd()
        $sr.Close()
        return $text
    } catch {}
    # Try uncompressed — check if it looks like PDF content stream
    $text = [System.Text.Encoding]::Latin1.GetString($raw)
    if ($text -match '\b(BT|ET|Tj|TJ|Td|Tm)\b') { return $text }
    return $null
}

function Extract-TextFromStream([string]$streamText) {
    $lines = [System.Collections.Generic.List[string]]::new()
    $currentLine = [System.Text.StringBuilder]::new()

    # Process BT..ET blocks for text operators
    $btBlocks = [regex]::Matches($streamText, 'BT\b(.*?)ET\b', [System.Text.RegularExpressions.RegexOptions]::Singleline)
    foreach ($block in $btBlocks) {
        $blockText = $block.Groups[1].Value

        # Detect line breaks via Td/TD/Tm operators (vertical movement)
        $ops = [regex]::Split($blockText, '(?=\r?\n)')
        foreach ($op in $ops) {
            # Td/TD with significant Y displacement = new line
            if ($op -match '[\d.\-]+\s+([\d.\-]+)\s+Td' -or $op -match '[\d.\-]+\s+([\d.\-]+)\s+TD') {
                $yMove = [double]$Matches[1]
                if ([Math]::Abs($yMove) -gt 1 -and $currentLine.Length -gt 0) {
                    $lines.Add($currentLine.ToString())
                    $currentLine.Clear()
                }
            }

            # Tj operator: (text) Tj
            $tjMatches = [regex]::Matches($op, '\(([^)]*)\)\s*Tj')
            foreach ($tj in $tjMatches) {
                $currentLine.Append($tj.Groups[1].Value) | Out-Null
            }

            # ' operator (move to next line and show text)
            $quoteMatches = [regex]::Matches($op, "\(([^)]*)\)\s*'")
            foreach ($qm in $quoteMatches) {
                if ($currentLine.Length -gt 0) {
                    $lines.Add($currentLine.ToString())
                    $currentLine.Clear()
                }
                $currentLine.Append($qm.Groups[1].Value) | Out-Null
            }

            # TJ operator: [(text) num (text) ...] TJ
            $tjArrays = [regex]::Matches($op, '\[(.*?)\]\s*TJ')
            foreach ($arr in $tjArrays) {
                $parts = [regex]::Matches($arr.Groups[1].Value, '\(([^)]*)\)|<([^>]+)>|([\-\d]+)')
                foreach ($part in $parts) {
                    if ($part.Groups[1].Value) {
                        $currentLine.Append($part.Groups[1].Value) | Out-Null
                    } elseif ($part.Groups[2].Value) {
                        $hex = ConvertFrom-HexString $part.Groups[2].Value
                        $currentLine.Append($hex) | Out-Null
                    } elseif ($part.Groups[3].Value) {
                        $kern = [int]$part.Groups[3].Value
                        if ($kern -lt -100) {
                            $currentLine.Append(' ') | Out-Null
                        }
                    }
                }
            }
        }
        if ($currentLine.Length -gt 0) {
            $lines.Add($currentLine.ToString())
            $currentLine.Clear()
        }
    }

    # Fallback: if BT/ET parsing yielded nothing, grab raw parenthesized strings
    if ($lines.Count -eq 0) {
        $fallback = [regex]::Matches($streamText, '\(([^)]+)\)')
        foreach ($fb in $fallback) {
            $val = $fb.Groups[1].Value
            if ($val -match '[a-zA-Z]{2,}' -and $val.Length -gt 2) {
                $lines.Add($val)
            }
        }
    }

    return $lines
}

# --- Main extraction loop ---
$pageNum = 0
$output = [System.Collections.Generic.List[string]]::new()

foreach ($sm in $streamMatches) {
    $raw = [System.Text.Encoding]::Latin1.GetBytes($sm.Groups[1].Value)
    $streamText = Get-StreamText $raw
    if (-not $streamText) { continue }

    # Skip streams that don't look like page content
    if ($streamText -notmatch '\b(BT|Tj|TJ)\b') { continue }

    $pageNum++
    $lines = Extract-TextFromStream $streamText
    $pageLines = [System.Collections.Generic.List[string]]::new()
    foreach ($line in $lines) {
        $clean = $line -replace '\\n', "`n" -replace '\\r', '' -replace '\\t', ' '
        if (-not (Test-Noise $clean)) {
            $pageLines.Add($clean)
        }
    }
    if ($pageLines.Count -gt 0) {
        $output.Add("--- Page $pageNum ---")
        foreach ($pl in $pageLines) { $output.Add($pl) }
        $output.Add('')
    }
}

if ($pageCount -and $pageNum -eq 0) {
    Write-Warning "No text content streams found in $pageCount-page PDF (may use image-only pages or unsupported encoding)"
}

$output -join "`n"
