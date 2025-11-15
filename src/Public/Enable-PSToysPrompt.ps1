function Enable-PSToysPrompt {
    <#
    .SYNOPSIS
        Enables a prompt that auto-cleans duplicate history and integrates with posh-git if available.
    .DESCRIPTION
        Replaces the current prompt. Each execution prunes duplicate PSReadLine history lines.
    .EXAMPLE
        Enable-PSToysPrompt
    #>
    Set-Item -Path Function:prompt -Value {
        Remove-DuplicateHistory
        if (Get-Command Write-VcsStatus -ErrorAction SilentlyContinue) {
            & $GitPromptScriptBlock
        }
        else {
            "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) "
        }
    }
}
