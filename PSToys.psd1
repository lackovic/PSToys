@{
    RootModule        = 'src/PSToys.psm1'
    ModuleVersion     = '1.0.1'
    GUID              = '8e2cb56e-6e8c-4f64-9f39-3df0b7b2a4a2'
    Author            = 'Marco Lackovic'
    CompanyName       = ''
    Copyright         = '(c) Marco Lackovic. All rights reserved.'
    Description       = 'PSToys: a set of PowerShell utilities (drive stats, user profiles, explorer restart, enhanced findstr, PSReadLine history management, optional prompt).'
    PowerShellVersion = '5.1'
    CompatiblePSEditions = @('Desktop','Core')
    FunctionsToExport = @('Get-Drives','Get-Users','Restart-Explorer','findstr','Disable-History','Remove-KeywordFromHistory','Remove-DuplicateHistory')
    AliasesToExport   = @()
    CmdletsToExport   = @()
    VariablesToExport = @()
    PrivateData       = @{
        PSData = @{
            Tags       = @('utilities','history','filesystem','prompt','powershell')
            LicenseUri = 'https://raw.githubusercontent.com/lackovic/PSToys/main/LICENSE'
            ProjectUri = 'https://github.com/lackovic/PSToys'
            IconUri    = ''
            ReleaseNotes = 'Initial module extraction from profile script.'
        }
    }
}