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
        $input | & findstr.exe /I $args | ForEach-Object {
            $_ -replace "(?i)($pattern)", "$([char]27)[91m`$1$([char]27)[0m"
        }
    }
    else {
        $pattern = $args[0]
        & findstr.exe /I $args | ForEach-Object {
            $_ -replace "(?i)($pattern)", "$([char]27)[91m`$1$([char]27)[0m"
        }
    }
}
