<#
PSToys Module Root (src/PSToys.psm1)
Dot-sources public function scripts from Public directory.
#>

# ===== posh-git integration =====
$poshGitName = 'posh-git'

# Ensure posh-git is installed if missing
if (-not (Get-Module -ListAvailable -Name $poshGitName)) {
    if (Get-Command -Name Install-Module -ErrorAction SilentlyContinue) {
        try {
            Install-Module -Name $poshGitName -Scope CurrentUser -Force -ErrorAction Stop
            Write-Verbose "PSToys: Installed posh-git."
        }
        catch {
            Write-Verbose "PSToys: posh-git install failed: $($_.Exception.Message)"
        }
    }
}

# Import posh-git if available
if (Get-Module -ListAvailable -Name $poshGitName) {
    if (-not (Get-Module -Name $poshGitName)) {
        try {
            Import-Module $poshGitName -ErrorAction Stop
            Write-Verbose "PSToys: posh-git module imported."
        }
        catch {
            Write-Verbose "PSToys: posh-git import failed: $($_.Exception.Message)"
        }
    }
    if ($GitPromptSettings -and $GitPromptSettings.DefaultPromptPrefix) {
        $GitPromptSettings.DefaultPromptPrefix.Text = '$(Get-Date -f "HH:mm:ss") '
        $GitPromptSettings.DefaultPromptPrefix.ForegroundColor = [ConsoleColor]::Magenta
    }
}

# ===== Terminal-Icons integration =====
$terminalIconsName = 'Terminal-Icons'

# Ensure Terminal-Icons is installed if missing
if (-not (Get-Module -ListAvailable -Name $terminalIconsName)) {
    if (Get-Command -Name Install-Module -ErrorAction SilentlyContinue) {
        try {
            Install-Module -Name $terminalIconsName -Scope CurrentUser -Force -ErrorAction Stop
            Write-Verbose "PSToys: Installed Terminal-Icons."
        }
        catch {
            Write-Verbose "PSToys: Terminal-Icons install failed: $($_.Exception.Message)"
        }
    }
}

# Import Terminal-Icons if available
if (Get-Module -ListAvailable -Name $terminalIconsName) {
    if (-not (Get-Module -Name $terminalIconsName)) {
        try {
            Import-Module $terminalIconsName -ErrorAction Stop
            Write-Verbose "PSToys: Terminal-Icons module imported."
        }
        catch {
            Write-Verbose "PSToys: Terminal-Icons import failed: $($_.Exception.Message)"
        }
    }
}

# Dot-source all public function scripts
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
