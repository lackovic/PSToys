function Remove-KeywordFromHistory {
    <#
    .SYNOPSIS
        Removes persistent PSReadLine history lines containing a keyword.
    .PARAMETER Keyword
        Keyword to filter out.
    .EXAMPLE
        Remove-KeywordFromHistory password
    .EXAMPLE
        Remove-KeywordFromHistory secret
    .NOTES
        Backward compatibility alias: Remove-PSReadLineHistoryByKeyword
    #>
    param(
        [Parameter(Mandatory = $true)]
        [string]$Keyword
    )
    $historyPath = (Get-PSReadlineOption).HistorySavePath
    if (Test-Path $historyPath) {
        $lines = Get-Content $historyPath
        $filtered = $lines | Where-Object { $_ -notlike "*$Keyword*" }
        $removedCount = $lines.Count - $filtered.Count
        $filtered | Set-Content $historyPath
        Write-Host "Removed $removedCount entries from persistent PSReadLine history." -ForegroundColor Green
    }
    else {
        Write-Host "PSReadLine history file not found at $historyPath." -ForegroundColor Yellow
    }
}
