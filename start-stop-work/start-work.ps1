# Opening Powershell as Admin
param([switch]$Elevated)

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false)  {
    if ($elevated) {        
    } else {
        Start-Process powershell.exe -Verb RunAs -ArgumentList ('-noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
    }
    exit
}

# Imports
. "C:\path\to\functions-work.ps1"

Start-HyperV; Start-Sleep -Seconds 2

Open-RDP; Start-Sleep -Seconds 45

# Start a new PowerShell session to open SOCKS tunnel
Open-Tunnel; Start-Sleep -Seconds 10

# The script continues here without waiting for the SSH connection to close
# sleep to wait for login input for tunnel, change windows proxy settings to the newly opened tunnel, and then start Edge
Start-Proxy; Start-Sleep -Seconds 2

Start-Firefox