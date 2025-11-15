function Get-Drives {
    <#
    .SYNOPSIS
        Lists all drives with their total, used and free space.
    .DESCRIPTION
        Displays information about all fixed drives including total space, used space, free space, and recycle bin size.
    .EXAMPLE
        Get-Drives
    #>
    $shell = New-Object -ComObject Shell.Application
    Get-PSDrive -PSProvider FileSystem |
    Where-Object { $_.Root -match '^[A-Z]:\\$' } |
    Select-Object Root,
    @{Name = 'Total(GB)'; Expression = { [math]::Round(($_.Used + $_.Free) / 1GB, 2) } },
    @{Name = 'Used(GB)'; Expression = { [math]::Round($_.Used / 1GB, 2) } },
    @{Name = 'Free(GB)'; Expression = { [math]::Round($_.Free / 1GB, 2) } },
    @{Name = 'RecycleBin(GB)'; Expression = {
            $driveLetter = $_.Root.Substring(0, 2)
            try {
                $recycleBin = $shell.Namespace(0xA).Items() | Where-Object { $_.Path -like "$driveLetter*" }
                $size = ($recycleBin | Measure-Object -Property Size -Sum).Sum
                [math]::Round($size / 1GB, 2)
            }
            catch { 0 }
        }
    }
}
