# Definir variáveis
$imageUrl = "https://c4.wallpaperflare.com/wallpaper/966/989/139/shrek-movies-animated-movies-dreamworks-hd-wallpaper-preview.jpg"
$imagePath = "$env:TEMP\doge.jpg"

# Baixar a imagem
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

# Verificar se a imagem foi baixada
if (Test-Path $imagePath) {
    Write-Host "Imagem baixada com sucesso."

    # Define o papel de parede no registro
    reg add "HKCU\Control Panel\Desktop" /v WallPaper /t REG_SZ /d $imagePath /f

    # Força a atualização do papel de parede usando a API SystemParametersInfo
    Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
    # SPI_SETDESKWALLPAPER = 20, SPIF_UPDATEINIFILE = 0x01, SPIF_SENDWININICHANGE = 0x02, juntos: 3
    [Wallpaper]::SystemParametersInfo(20, 0, $imagePath, 3)

    Write-Host "Papel de parede alterado com sucesso."
}
else {
    Write-Host "Erro ao baixar a imagem."
}
