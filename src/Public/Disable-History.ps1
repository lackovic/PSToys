function Disable-History {
    <#
    .SYNOPSIS
        Disables persistent PSReadLine history for the current session.
    .EXAMPLE
        Disable-History
    #>
    $global:PSReadLineOldHistorySaveStyle = (Get-PSReadLineOption).HistorySaveStyle
    Set-PSReadLineOption -HistorySaveStyle SaveNothing
    Write-Host "Persistent PSReadLine history disabled for this session." -ForegroundColor Yellow
}
