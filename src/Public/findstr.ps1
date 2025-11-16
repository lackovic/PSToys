function findstr {
    <#
    .SYNOPSIS
        Wrapper for findstr.exe providing case-insensitive colored matches and /v (invert) support.
    .DESCRIPTION
        Supports the /v switch to invert matches (show lines that do NOT contain the pattern) for both piped input and file searches.
    .PARAMETER pattern
        Pattern to search (first non-switch argument). Additional arguments are passed to findstr.exe when not using piped input.
    .EXAMPLE
        findstr error *.log
    .EXAMPLE
        Get-Content app.log | findstr timeout
    .EXAMPLE
        Get-Content app.log | findstr /v error
    .EXAMPLE
        findstr /v error *.log
    #>
    # Separate switches (starting with /) from other arguments
    $switches = @()
    $others   = @()
    foreach ($a in $args) {
        if ($a -is [string] -and $a.StartsWith('/')) { $switches += $a } else { $others += $a }
    }

    if (-not $others) { return }
    $pattern = $others[0]
    $invert = $switches | Where-Object { $_ -match '^/v$' } | ForEach-Object { $true } | Select-Object -First 1
    if (-not $invert) { $invert = $false }

    if ($input) {
        $prevEncoding = [Console]::OutputEncoding
        try {
            [Console]::OutputEncoding = [System.Text.UTF8Encoding]::UTF8
            $lines = if ($invert) {
                $input | Where-Object { $_ -notmatch $pattern }
            }
            else {
                $input | Where-Object { $_ -match $pattern }
            }
            $lines | ForEach-Object {
                # Repair common UTF-8 mojibake for ellipsis
                $line = $_ -replace 'â€¦', '…' -replace 'ΓÇª', '…'
                if (-not $invert) {
                    $line -replace "(?i)($pattern)", "$([char]27)[91m`$1$([char]27)[0m"
                }
                else {
                    $line
                }
            }
        }
        finally {
            [Console]::OutputEncoding = $prevEncoding
        }
    }
    else {
        # Build argument list for external findstr.exe
        $cmdArgs = @()
        # Ensure case-insensitive by default (existing behavior) unless user explicitly specified /I or /i
        if (-not ($switches -contains '/I' -or $switches -contains '/i')) { $cmdArgs += '/I' }
        $cmdArgs += $switches
        $cmdArgs += $others
        & findstr.exe $cmdArgs | ForEach-Object {
            if (-not $invert) {
                $_ -replace "(?i)($pattern)", "$([char]27)[91m`$1$([char]27)[0m"
            }
            else {
                $_
            }
        }
    }
}
