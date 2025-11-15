function Restart-Explorer {
    <#
    .SYNOPSIS
        Restarts Windows Explorer (useful if taskbar disappears).
    .EXAMPLE
        Restart-Explorer
    #>
    Stop-Process -Name explorer -Force
}
