Set-ExecutionPolicy Bypass -Force

# Verifica se o serviço do Monitoo já existe na máquina, significando que a instalação já ocorreu

$service = Get-Service -Name "Monitoo.Service" -ErrorAction SilentlyContinue

if ($service) {
    return
}

Invoke-WebRequest -Uri 'https://github.com/maikeg-alves/maikeg-alves/raw/refs/heads/main/norma.msi' -OutFile C:\Users\Public\Monitoo-Instalador.msi

C:\Users\Public\Monitoo-Instalador.msi /q token=e9081e5d-41be-4bec-bcf6-023fae1f3add

Start-Sleep -Seconds 15

Remove-Item -Path "C:\Users\Public\Monitoo-Instalador.msi" -Force