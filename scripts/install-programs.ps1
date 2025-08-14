# Lista de programas para instalar via Winget
$appsWinget = @(
    "Google.Chrome",
    "AnyDesk.AnyDesk",
    "Google.GoogleDrive"
)

foreach ($app in $appsWinget) {
    Write-Host "Instalando $app via Winget..." -ForegroundColor Cyan
    Start-Process "winget" -ArgumentList "install --id $app --silent --accept-source-agreements --accept-package-agreements" -Wait
}

# Instalar o PABX via MSI direto
$pabxUrl = "https://github.com/maikeg-alves/maikeg-alves/raw/refs/heads/main/softwares/ERAphone-3.21.4-PT.msi"
$tempPath = Join-Path $env:TEMP "PABX.msi"

Write-Host "Baixando e instalando PABX..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $pabxUrl -OutFile $tempPath -UseBasicParsing
Start-Process "msiexec.exe" -ArgumentList "/i `"$tempPath`" /quiet /norestart" -Wait
Remove-Item $tempPath -Force -ErrorAction SilentlyContinue

Write-Host "Todas as instalações concluídas!" -ForegroundColor Green
