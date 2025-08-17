# Define os endereços DNS primário e secundário
$PrimaryDNS = "192.168.45.33"
$SecondaryDNS = "8.8.8.8"

# Pega todas as interfaces de rede ativas e as salva na variável $Interfaces
$Interfaces = Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.InterfaceDescription -notlike "*loopback*" -and $_.InterfaceDescription -notlike "*virtual*" }

# Verifica se encontrou alguma interface
if ($Interfaces.Count -eq 0) {
    Write-Host "Nenhuma interface de rede ativa encontrada para configurar." -ForegroundColor Yellow
} else {
    # Para cada interface encontrada, configura o DNS
    foreach ($Interface in $Interfaces) {
        try {
            Set-DnsClientServerAddress -InterfaceAlias $Interface.Name -ServerAddresses ($PrimaryDNS, $SecondaryDNS)
            Write-Host "DNS configurado com sucesso para '$($Interface.Name)': $PrimaryDNS e $SecondaryDNS." -ForegroundColor Green
        }
        catch {
            Write-Host "Erro ao configurar DNS para a interface '$($Interface.Name)': $_" -ForegroundColor Red
        }
    }
}
