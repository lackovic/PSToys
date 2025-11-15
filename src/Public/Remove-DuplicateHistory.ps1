function Remove-DuplicateHistory {
    <#
    .SYNOPSIS
        Removes duplicate PSReadLine history entries keeping only last occurrence.
    .EXAMPLE
        Remove-DuplicateHistory
    #>
    $historyPath = (Get-PSReadlineOption).HistorySavePath
    if (Test-Path $historyPath) {
        $lines = Get-Content $historyPath
        $lastIndex = @{}
        for ($i = 0; $i -lt $lines.Count; $i++) { $lastIndex[$lines[$i]] = $i }
        $unique = for ($i = 0; $i -lt $lines.Count; $i++) { if ($lastIndex[$lines[$i]] -eq $i) { $lines[$i] } }
        $removedCount = $lines.Count - $unique.Count
        if ($removedCount -gt 0) { $unique | Set-Content $historyPath }
    }
}
