# Lista de programas para instalar (MSI ou EXE, por URL ou Diretório)
$apps = @(
<#     @{ Name = "Google Chrome"; Url = "https://dl.google.com/tag/s/appguid%3D%7B8A69D345-D564-463C-AFF1-A69D9E530F96%7D%26iid%3D%7BD6BFE8A1-7337-41CD-CBA0-9D9D7181EBE6%7D%26browser%3D4%26usagestats%3D0%26appname%3DGoogle%2520Chrome%26needsadmin%3Dtrue%26ap%3Dx64-stable-statsdef_0%26brand%3DGCEA/dl/chrome/install/googlechromestandaloneenterprise64.msi"; Path = "" },
    @{ Name = "AnyDesk"; Url = "https://download.anydesk.com/AnyDesk.exe"; Path = "" },
    @{ Name = "Google Drive"; Url = ""; Path = "C:\Install\GoogleDriveSetup.exe" }, #>
    @{ Name = "Ninite"; Url = ""; Path = "C:\Install\Ninite.exe" },
    @{ Name = "PABX"; Url = "https://github.com/maikeg-alves/maikeg-alves/raw/refs/heads/main/softwares/ERAphone-3.21.4-PT.msi"; Path = "" }
)

function Install-FromUrl {
    param($url, $name)
    $fileName = Split-Path $url -Leaf
    $tempPath = Join-Path $env:TEMP $fileName

    Write-Host "Baixando $name..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $url -OutFile $tempPath -UseBasicParsing

    Install-File-Silent $tempPath $name

    Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
}

function Install-FromPath {
    param($path, $name)
    if (Test-Path $path) {
        Write-Host "Instalando $name do diretório local (modo normal)..." -ForegroundColor Cyan
        Start-Process $path -Wait
    } else {
        Write-Host "Arquivo não encontrado para $name no caminho $path" -ForegroundColor Red
    }
}

function Install-File-Silent {
    param($filePath, $name)
    $extension = [System.IO.Path]::GetExtension($filePath).ToLower()

    try {
        if ($extension -eq ".msi") {
            Write-Host "Instalando $name (MSI - silencioso)..." -ForegroundColor Yellow
            Start-Process "msiexec.exe" -ArgumentList "/i `"$filePath`" /quiet /norestart" -Wait -ErrorAction Stop
        }
        elseif ($extension -eq ".exe") {
               switch ($name) {
                "AnyDesk" {
                    Write-Host "Instalando AnyDesk (parâmetros oficiais)..." -ForegroundColor Yellow
                    Start-Process $filePath -ArgumentList "--install `"C:\Program Files (x86)\AnyDesk`" --start-with-win --create-desktop-icon --silent" -Wait -ErrorAction Stop
                }
                "Google Drive" {
                    Write-Host "Instalando Google Drive (instalação normal, sem silencioso)..." -ForegroundColor Yellow
                    Start-Process $filePath -Wait -ErrorAction Stop
                }
                default {
                    Write-Host "Instalando $name (EXE - sem parâmetros personalizados)..." -ForegroundColor Yellow
                    Start-Process $filePath -Wait -ErrorAction Stop
                }
        }
        else {
            throw "Formato não reconhecido"
        }
    }
    catch {
        Write-Host "Falha na instalação silenciosa de $name. Tentando instalação normal..." -ForegroundColor Red
        Start-Process $filePath -Wait
    }
}

foreach ($app in $apps) {
    Write-Host "`nProcessando: $($app.Name)" -ForegroundColor Magenta

    if ($app.Path -and $app.Path.Trim() -ne "") {
        Install-FromPath $app.Path $app.Name
    }
    elseif ($app.Url -and $app.Url.Trim() -ne "") {
        Install-FromUrl $app.Url $app.Name
    }
    else {
        Write-Host "Nenhuma fonte de instalação definida para $($app.Name)." -ForegroundColor Red
    }
}

Write-Host "`nTodas as instalações concluídas!" -ForegroundColor Green
