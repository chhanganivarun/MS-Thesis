<#
.SYNOPSIS
    Builds thesis.pdf with XeLaTeX + BibTeX.

.DESCRIPTION
    The document loads fontspec and polyglossia, so it must be built with
    XeLaTeX; pdfLaTeX will not work. -shell-escape is required so that
    graphicx can convert figures/iiit.eps to PDF via Ghostscript.

.EXAMPLE
    .\build.ps1
    .\build.ps1 -Clean
#>
[CmdletBinding()]
param(
    # Remove auxiliary files (and the converted EPS) before building.
    [switch]$Clean,
    # Delete auxiliary files and exit without building.
    [switch]$CleanOnly
)

$ErrorActionPreference = 'Stop'
Set-Location -LiteralPath $PSScriptRoot

# Terminals opened before MiKTeX was installed keep a stale PATH. Resolve the
# binaries ourselves so .\build.ps1 works without restarting the shell.
function Resolve-MiKTeXBin {
    $fromPath = Get-Command xelatex -ErrorAction SilentlyContinue
    if ($fromPath) { return Split-Path -Parent $fromPath.Source }

    $candidates = @(
        (Join-Path $env:LOCALAPPDATA 'Programs\MiKTeX\miktex\bin\x64'),
        (Join-Path ${env:ProgramFiles} 'MiKTeX\miktex\bin\x64'),
        (Join-Path ${env:ProgramFiles(x86)} 'MiKTeX\miktex\bin\x64')
    )
    foreach ($dir in $candidates) {
        if ($dir -and (Test-Path (Join-Path $dir 'xelatex.exe'))) { return $dir }
    }

    throw @'
xelatex was not found. Install MiKTeX (winget install MiKTeX.MiKTeX), then either
open a new terminal or re-run this script so it can pick up the MiKTeX bin path.
'@
}

$miktexBin = Resolve-MiKTeXBin
$xelatex = Join-Path $miktexBin 'xelatex.exe'
$bibtex  = Join-Path $miktexBin 'bibtex.exe'
Write-Host "Using MiKTeX tools from $miktexBin" -ForegroundColor DarkGray

$jobName = 'thesis'
$auxPatterns = @(
    "$jobName.aux", "$jobName.bbl", "$jobName.blg", "$jobName.log",
    "$jobName.lof", "$jobName.lot", "$jobName.toc", "$jobName.out",
    "$jobName.fls", "$jobName.fdb_latexmk", "$jobName.synctex.gz",
    "$jobName.xdv", 'figures/*-eps-converted-to.pdf'
)

function Remove-AuxFiles {
    foreach ($pattern in $auxPatterns) {
        Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | ForEach-Object {
            Remove-Item $_.FullName -Force
            Write-Host "  removed $($_.Name)" -ForegroundColor DarkGray
        }
    }
}

if ($Clean -or $CleanOnly) {
    Write-Host 'Cleaning auxiliary files...' -ForegroundColor Cyan
    Remove-AuxFiles
    if ($CleanOnly) { return }
}

function Invoke-Step {
    param([string]$Label, [string]$Exe, [string[]]$Arguments, [switch]$AllowFailure)

    Write-Host "==> $Label" -ForegroundColor Cyan
    # MiKTeX writes advisory notices to stderr; under 'Stop' those would abort
    # the script even though the tool itself succeeded.
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try { & $Exe @Arguments | Out-Host } finally { $ErrorActionPreference = $previous }

    if ($LASTEXITCODE -ne 0 -and -not $AllowFailure) {
        throw "$Label failed with exit code $LASTEXITCODE. See $jobName.log for details."
    }
}

$xelatexArgs = @('-interaction=nonstopmode', '-shell-escape', '-synctex=1', "$jobName.tex")

Invoke-Step 'XeLaTeX (pass 1/3)' $xelatex $xelatexArgs
# BibTeX exits non-zero on undefined citations, which should not abort the build.
Invoke-Step 'BibTeX' $bibtex @($jobName) -AllowFailure
Invoke-Step 'XeLaTeX (pass 2/3)' $xelatex $xelatexArgs
Invoke-Step 'XeLaTeX (pass 3/3)' $xelatex $xelatexArgs

$pdf = Join-Path $PSScriptRoot "$jobName.pdf"
if (-not (Test-Path $pdf)) {
    throw "Build finished but $jobName.pdf was not produced."
}

$pages = (Select-String -Path "$jobName.log" -Pattern 'Output written on .* \((\d+) pages' |
    Select-Object -Last 1).Matches.Groups[1].Value
Write-Host "`nBuilt $pdf ($pages pages)" -ForegroundColor Green

$undefined = Select-String -Path "$jobName.log" -Pattern 'Warning: (Citation|Reference|Label).*undefined'
if ($undefined) {
    Write-Host "$($undefined.Count) undefined citation/reference warning(s) in $jobName.log" -ForegroundColor Yellow
}
