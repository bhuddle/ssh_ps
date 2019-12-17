clear
Write-Host 'Please modify path and password before executing'
Set-ExecutionPolicy RemoteSigned

$GitWebAddress = 'https://github.com/PowerShell/Win32-OpenSSH/releases/download/v7.7.2.0p1-Beta/OpenSSH-Win64.zip'
$OpenSSHZip = 'C:\Users\USERNAME\Desktop\OpenSSH-Win64.zip'
$InstallPath = 'C:\'

###Download most recent OpenSSH
Write-Host 'Downloading file...'
(new-object System.Net.WebClient).DownloadFile($GitWebAddress,$OpenSSHZip)
Write-Host 'Download Complete' -ForegroundColor Green

Start-Sleep -s 3

###extract files
Write-Host 'Extracting file...'
(Expand-Archive -Path $OpenSSHZip -DestinationPath $InstallPath -Force)
Write-Host 'Extraction complete' -ForegroundColor Green
Write-Host 'Installing...'
powershell.exe -ExecutionPolicy Bypass -File C:\OpenSSH-Win64\install-sshd.ps1
Write-Host 'Removing: '$OpenSSHZip -ForegroundColor Yellow
Remove-Item -path $OpenSSHZip
Write-Host 'Installation and removal complete' -ForegroundColor Green

Start-Sleep -s 3

###Set Administrator password to 
Write-Host 'Set hostname Administrator to ' -NoNewLine
Write-Host 'PASSWORD' -ForegroundColor Red
net user Administrator PASSWORD

Start-Sleep -s 3

###Configure firewall rule
Write-Host 'Conigure firewall with windows'
if(-Not (get-NetFireWallRule -Name 'sshd').Enabled) {
(New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH SSH Server' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22)
} else { Write-Host 'Firewall already exists' -ForegroundColor Yellow
}
sc.exe config sshd start= auto
sc.exe start sshd
Write-Host 'Setup and configuration complete' -ForegroundColor Green