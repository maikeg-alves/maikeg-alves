# Definir variáveis
$imageUrl = "https://c4.wallpaperflare.com/wallpaper/966/989/139/shrek-movies-animated-movies-dreamworks-hd-wallpaper-preview.jpg"
$imagePath = "$env:TEMP\doge.jpg"

# Baixar a imagem
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

# Verificar se a imagem foi baixada
if (Test-Path $imagePath) {
    Write-Host "Imagem baixada com sucesso."

    # Define o papel de parede
    reg add "HKCU\Control Panel\Desktop" /v WallPaper /t REG_SZ /d $imagePath /f

    # Aplica as mudanças
    RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters , 1 , True .\.env

    RUNDLL32.EXE USER32.DLL, UpdatePerUserSystemParameters

    # Exibe mensagem de sucesso
    Write-Host "Papel de parede alterado com sucesso."

}
else {
    Write-Host "Erro ao baixar a imagem."
}
