$dotNetUrl = "https://go.microsoft.com/fwlink/?linkid=2088631"
$installer = "$env:TEMP\ndp48-x86-x64-allos-enu.exe"

Invoke-WebRequest -Uri $dotNetUrl -OutFile $installer
Start-Process -FilePath $installer -ArgumentList "/quiet", "/norestart" -Wait

Write-Output "Instalação concluída. Por favor, reinicie o sistema."
