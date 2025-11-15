# Releasing PSToys (Maintainers Only)

Regular users do NOT publish; they only install/update via:

```powershell
Install-Module PSToys
Update-Module PSToys
Import-Module PSToys
```

Publishing is restricted to the maintainer with a valid PowerShell Gallery (PSGallery) API key.

## Prerequisites

- PowerShell 5.1+ or PowerShell 7+
- Module manifest: `PSToys.psd1`
- PowerShellGet installed (built-in on Windows PowerShell 5.1; for PowerShell 7 ensure PowerShellGet module is available)
- PSGallery API key created at https://www.powershellgallery.com/ (Your profile -> API Keys)
- Clean working tree on `main`

## Release Steps

1. Decide version (e.g. bump from `1.0.0` to `1.0.1`).
1. Edit `PSToys.psd1`:
   - Change `ModuleVersion`.
   - Optionally update `PrivateData.PSData.ReleaseNotes`.
1. Smoke test locally:
   ```powershell
   Import-Module (Join-Path $PWD 'PSToys.psd1') -Force
   Get-Drives; Get-Users; findstr PSToys README.md
   ```
1. Commit and tag:
   ```powershell
   git add PSToys.psd1
   git commit -m "Release v1.0.1"
   git tag v1.0.1
   git push origin main --tags
   ```
1. Publish to PSGallery (run from repo root):
   ```powershell
   Publish-Module -Path . -NuGetApiKey '<YourGalleryApiKey>' -Repository PSGallery
   ```
   If you keep the API key in the secret store or environment, omit `-NuGetApiKey` and rely on existing configuration.
1. Verify:
   ```powershell
   Find-Module PSToys -Repository PSGallery
   Install-Module PSToys -Force -Scope CurrentUser
   Import-Module PSToys -Force
   Get-Module PSToys | Select Name,Version,Path
   ```
1. (Optional) Post-release: bump manifest version to next patch/minor with a `-dev` note in ReleaseNotes if you want to differentiate upcoming work.

## Troubleshooting

- 403 / auth errors: verify API key not expired; ensure you are publishing with the account that owns the module name.
- Name conflict: PSToys must already be reserved by initial publish; otherwise choose a unique name.
- Missing functions after install: confirm they are listed in `FunctionsToExport` in `PSToys.psd1`.

## Automation (Optional)

You can script release tagging & publishing:
```powershell
$next = '0.1.2'
(Get-Content PSToys.psd1) -replace "ModuleVersion\s*=\s*'[^']+'","ModuleVersion = '$next'" | Set-Content PSToys.psd1
Publish-Module -Path . -Repository PSGallery -NuGetApiKey $env:PSGALLERY_KEY
```
Ensure `$env:PSGALLERY_KEY` is set beforehand.

---
Maintainer reference only. Not for end-user execution.
