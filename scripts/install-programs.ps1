# Lista de programas para instalar (MSI ou EXE, por URL ou Diretório)
$apps = @(
    @{ Name = "Google Chrome"; WingetId = ""; Url = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BD6BFE8A1-7337-41CD-CBA0-9D9D7181EBE6%7D%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi"; Path = "" },
    @{ Name = "AnyDesk"; WingetId = ""; Url = "https://download.anydesk.com/AnyDesk.exe"; Path = "" },
    @{ Name = "Google Drive"; WingetId = "Google.GoogleDrive"; Url = ""; Path = "" }, # Instalação local normal
    @{ Name = "PABX"; WingetId = ""; Url = "https://github.com/maikeg-alves/maikeg-alves/raw/refs/heads/main/softwares/ERAphone-3.21.4-PT.msi"; Path = "" }
)

# Verifica se o Winget está disponível.
function Test-Winget {
    try {
        if ((Get-Command winget -ErrorAction SilentlyContinue) -ne $null) {
            return $true
        } else {
            return $false
        }
    }
    catch {
        return $false
    }
}

# Função para instalar via winget.
function Install-FromWinget {
    param($wingetId, $name)

    Write-Host "Tentando instalar $name via winget..." -ForegroundColor Cyan

    try {
        # Adiciona flags para aceitar contratos e instalar silenciosamente.
        Start-Process -FilePath "winget" -ArgumentList "install --id `"$wingetId`" --silent --accept-source-agreements --accept-package-agreements" -Wait -NoNewWindow
        
        # Verifica se o processo de winget teve sucesso.
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Instalação de $name via winget concluída com sucesso." -ForegroundColor Green
            return $true
        } else {
            Write-Host "Instalação de $name via winget falhou com código de erro: $LASTEXITCODE" -ForegroundColor Red
            return $false
        }
    }
    catch {
        Write-Host "Ocorreu um erro ao executar o winget para $name." -ForegroundColor Red
        return $false
    }
}

# Função para instalar de uma URL.
function Install-FromUrl {
    param($url, $name)
    $fileName = Split-Path $url -Leaf
    $tempPath = Join-Path $env:TEMP $fileName

    Write-Host "Baixando $name..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $url -OutFile $tempPath -UseBasicParsing -ErrorAction Stop
        Install-File-Silent $tempPath $name
    }
    catch {
        Write-Host "Falha ao baixar $name da URL." -ForegroundColor Red
        return $false
    }
    finally {
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        }
    }
    return $true
}

# Função para instalar de um caminho local.
function Install-FromPath {
    param($path, $name)
    if (Test-Path $path) {
        Write-Host "Instalando $name do diretório local (modo normal)..." -ForegroundColor Cyan
        Start-Process $path -Wait
        return $true
    } else {
        Write-Host "Arquivo não encontrado para $name no caminho $path" -ForegroundColor Red
        return $false
    }
}

# Função de instalação silenciosa para MSI/EXE.
function Install-File-Silent {
    param($filePath, $name)
    $extension = [System.IO.Path]::GetExtension($filePath).ToLower()

    try {
        if ($extension -eq ".msi") {
            Write-Host "Instalando $name (MSI - silencioso)..." -ForegroundColor Yellow
            Start-Process "msiexec.exe" -ArgumentList "/i `"$filePath`" /quiet /norestart" -Wait -ErrorAction Stop
        }
        elseif ($extension -eq ".exe") {
            Write-Host "Instalando $name (EXE - silencioso)..." -ForegroundColor Yellow
            # Argumentos comuns para instaladores EXE.
            Start-Process $filePath -ArgumentList "/S /silent /verysilent /quiet /norestart" -Wait -ErrorAction Stop
        }
        else {
            throw "Formato não reconhecido"
        }
    }
    catch {
        Write-Host "Falha na instalação silenciosa de $name. Tentando instalação normal..." -ForegroundColor Red
        # Tenta a instalação normal como fallback.
        Start-Process $filePath -Wait
    }
}

# ----- Loop Principal de Instalação -----
foreach ($app in $apps) {
    Write-Host "`nProcessando: $($app.Name)" -ForegroundColor Magenta
    
    $installed = $false

    # Tenta instalar via winget primeiro se o ID estiver presente
    if ($app.WingetId -and (Test-Winget)) {
        $installed = Install-FromWinget -wingetId $app.WingetId -name $app.Name
    }

    # Se a instalação via winget falhou ou não foi tentada, tenta o caminho local.
    if (-not $installed -and $app.Path -and $app.Path.Trim() -ne "") {
        $installed = Install-FromPath -path $app.Path -name $app.Name
    }

    # Se as opções anteriores falharam, tenta a URL.
    if (-not $installed -and $app.Url -and $app.Url.Trim() -ne "") {
        $installed = Install-FromUrl -url $app.Url -name $app.Name
    }

    if (-not $installed) {
        Write-Host "Nenhuma fonte de instalação bem-sucedida para $($app.Name)." -ForegroundColor Red
    }
}

Write-Host "`nTodas as instalações concluídas!" -ForegroundColor Green
