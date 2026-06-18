# Usage: .\rename-by-modtime.ps1 -FolderPath "C:\MyFolder" -Prefix "Backup"

param(
    [Parameter(Mandatory=$true)]
    [string]$FolderPath,

    [Parameter(Mandatory=$true)]
    [string]$Prefix
)

if (-not (Test-Path -Path $FolderPath -PathType Container)) {
    Write-Host "Error: folder not found - $FolderPath" -ForegroundColor Red
    exit 1
}

$files = Get-ChildItem -Path $FolderPath -File

if ($files.Count -eq 0) {
    Write-Host "No files found in the folder." -ForegroundColor Yellow
    exit 0
}

Write-Host "Found $($files.Count) file(s), renaming..." -ForegroundColor Cyan
Write-Host ""

$renamed = 0
$skipped = 0

foreach ($file in $files) {
    $modTime = $file.LastWriteTime
    $ext = $file.Extension
    $newName = "$Prefix-$($modTime.ToString('yyyyMMdd-HHmm'))$ext"

    if ($file.Name -eq $newName) {
        $skipped++
        continue
    }

    $newPath = Join-Path -Path $FolderPath -ChildPath $newName

    $counter = 1
    while (Test-Path -Path $newPath) {
        $newName = "$Prefix-$($modTime.ToString('yyyyMMdd-HHmm'))_$counter$ext"
        $newPath = Join-Path -Path $FolderPath -ChildPath $newName
        $counter++
    }

    try {
        Rename-Item -Path $file.FullName -NewName $newName -ErrorAction Stop
        Write-Host "$($file.Name) -> $newName"
        $renamed++
    }
    catch {
        Write-Host "Rename failed: $($file.Name) - $_" -ForegroundColor Red
        $skipped++
    }
}

Write-Host ""
Write-Host "Done: $renamed renamed, $skipped skipped" -ForegroundColor Green
