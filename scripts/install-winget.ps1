# Função para instalar o winget (App Installer)
function Install-Winget {
    Write-Host "Instalando Winget..." -ForegroundColor Cyan
    
    # Link oficial do App Installer (MSIXBundle)
    $wingetUrl = "https://aka.ms/getwinget"
    $tempPath = Join-Path $env:TEMP "AppInstaller.msixbundle"
    
    Invoke-WebRequest -Uri $wingetUrl -OutFile $tempPath -UseBasicParsing
    
    # Instalar o pacote
    Add-AppxPackage -Path $tempPath
    
    # Remover instalador temporário
    Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
}

# Função para verificar se o winget está disponível
function Test-Winget {
    return (Get-Command winget -ErrorAction SilentlyContinue) -ne $null
}

# Se não tiver winget, instala
if (-not (Test-Winget)) {
    Install-Winget
} else {
    Write-Host "Winget já está instalado." -ForegroundColor Green
}
