@'
Add-Type -AssemblyName PresentationFramework
[System.Windows.MessageBox]::Show('Sistema atualizado com sucesso','Windows Update')
'@ | Set-Content -Path "C:\Temp\mensagem.ps1" -Encoding UTF8