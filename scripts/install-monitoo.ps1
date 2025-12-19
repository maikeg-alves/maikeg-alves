Set-ExecutionPolicy Bypass -Force

$service = Get-Service -Name "Monitoo.Service" -ErrorAction SilentlyContinue
if ($service) {
    return
}

Invoke-WebRequest `
  -Uri "https://github.com/maikeg-alves/maikeg-alves/raw/refs/heads/main/norma.msi" `
  -OutFile "C:\Users\Public\Monitoo-Instalador.msi"

Start-Process "C:\Users\Public\Monitoo-Instalador.msi" `
  -ArgumentList "/q token=e9081e5d-41be-4bec-bcf6-023fae1f3add" `
  -Wait

Start-Sleep -Seconds 15

Remove-Item "C:\Users\Public\Monitoo-Instalador.msi" -Force
