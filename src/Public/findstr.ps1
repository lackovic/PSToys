function findstr {
    <#
    .SYNOPSIS
        Wrapper for findstr.exe providing case-insensitive colored matches.
    .PARAMETER pattern
        Pattern to search (first argument).
    .EXAMPLE
        findstr error *.log
    .EXAMPLE
        Get-Content app.log | findstr timeout
    #>
    if ($input) {
        $pattern = $args[0]
        $prevEncoding = [Console]::OutputEncoding
        try {
            [Console]::OutputEncoding = [System.Text.UTF8Encoding]::UTF8
            # Use PowerShell's regex matching for piped input to preserve Unicode characters
            $input | Where-Object { $_ -match $pattern } | ForEach-Object {
                # Repair common UTF-8 mojibake for ellipsis produced when upstream command output
                # was decoded with the wrong code page before reaching this function
                $line = $_ -replace 'â€¦', '…' -replace 'ΓÇª', '…'
                $line -replace "(?i)($pattern)", "$([char]27)[91m`$1$([char]27)[0m"
            }
        }
        finally {
            [Console]::OutputEncoding = $prevEncoding
        }
    }
    else {
        $pattern = $args[0]
        & findstr.exe /I $args | ForEach-Object {
            $_ -replace "(?i)($pattern)", "$([char]27)[91m`$1$([char]27)[0m"
        }
    }
}
