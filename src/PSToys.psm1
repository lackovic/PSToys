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

# Don't record any space-prefixed commands, any semicolon-prefixed commands, or commands shorter than 4 chars
if (Get-Command Set-PSReadLineOption -ErrorAction SilentlyContinue) {
    Set-PSReadLineOption -AddToHistoryHandler {
        param([string]$line)
        if (-not $line) { return $false }
        # Exclude leading space (privacy), leading semicolon, and very short commands (<=3)
        if ($line.StartsWith(' ') -or $line.StartsWith(';')) { return $false }
        if ($line.Length -le 3) { return $false }
        return $true
    }
}

# Key binding: Ctrl+D exits the shell (ViExit)
if (Get-Command Set-PSReadLineKeyHandler -ErrorAction SilentlyContinue) {
    Set-PSReadLineKeyHandler -Key ctrl+d -Function ViExit
}

Export-ModuleMember -Function Get-Drives, Get-Users, Restart-Explorer, findstr, Disable-History, Remove-KeywordFromHistory, Remove-DuplicateHistory
