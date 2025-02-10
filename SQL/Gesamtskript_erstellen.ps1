$mergedFileName = "Gesamtskript.sql"
$sqlDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$mergedFilePath = Join-Path $sqlDirectory $mergedFileName

Write-Host "Überprüfe den Inhalt des SQL-Verzeichnisses: $sqlDirectory"
Get-ChildItem -Path $sqlDirectory -Recurse -Force | Write-Host

if (Test-Path $mergedFilePath) {
    Remove-Item $mergedFilePath
}

# Alle Ordner alphabetisch sortiert holen
$folders = Get-ChildItem -Path $sqlDirectory -Recurse -Directory | Sort-Object Name

# Dateien aus den Ordnern und Unterordnern sammeln
foreach ($folder in $folders) {
    Write-Host "Verarbeite Ordner: $($folder.FullName)"
    
    # Dateien innerhalb des aktuellen Ordners alphabetisch sortieren und verarbeiten
    $folderFiles = Get-ChildItem -Path $folder.FullName -File -Filter "*.sql" | Sort-Object Name
    foreach ($file in $folderFiles) {
        Write-Host "Verarbeite Datei: $($file.FullName)"
        "`n-- Hinzufügen: $($file.Name)`n" | Add-Content -Path $mergedFilePath -Encoding utf8
        Get-Content $file.FullName | Add-Content -Path $mergedFilePath -Encoding utf8
        "`n-- Fertig: $($file.Name)`n" | Add-Content -Path $mergedFilePath -Encoding utf8
    }
}

Write-Host "Gesamtskript erstellt: $mergedFilePath"
# Warten auf Tastendruck bevor das Skript beendet wird
Write-Host "Enter um fortzufahren..."
Read-Host