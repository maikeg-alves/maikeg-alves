# Desabilitar Notícias e Interesses

Write-Host "Desabilitando Notícias e Interesses..."

TASKKILL /IM explorer.exe /F

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Feeds" -Name "ShellFeedsTaskbarViewMode" -Type DWord -Value 2

Start-Process explorer.exe
