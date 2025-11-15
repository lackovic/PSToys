<#
PSToys Module Root (src/PSToys.psm1)
Dot-sources public function scripts from Public directory.
#>
$publicPath = Join-Path $PSScriptRoot 'Public'
if (Test-Path $publicPath) {
    Get-ChildItem -Path $publicPath -Filter *.ps1 | ForEach-Object { . $_.FullName }
}

# Automatically install custom prompt on import
Set-Item -Path Function:prompt -Value {
    Remove-DuplicateHistory
    if (Get-Command Write-VcsStatus -ErrorAction SilentlyContinue) {
        & $GitPromptScriptBlock
    }
    else {
        "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
    }
} -ErrorAction SilentlyContinue

# Don't record space-prefixed or semicolon-prefixed short commands
Set-PSReadLineOption -AddToHistoryHandler {
    param([string]$line)
    $line.Length -gt 3 -and $line[0] -ne ' ' -and $line[0] -ne ';'
}

# Key binding: Ctrl+D exits the shell (ViExit)
if (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) {
    Set-PSReadLineKeyHandler -Key ctrl+d -Function ViExit
}

Export-ModuleMember -Function Get-Drives, Get-Users, Restart-Explorer, findstr, Disable-History, Remove-KeywordFromHistory, Remove-DuplicateHistory
