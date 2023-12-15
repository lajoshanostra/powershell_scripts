#### Function Library for start-work.ps1 and stop-work.ps1 ####

# Replace all values below here at the start of the script
# and the values for the URLs in the function Start-Firefox $urls array

# Define Hyper-V VM details
$vm = "VM Name" # <-- Replace with your VM's VM name
$hostname = "Hostname" # <-- Replace with your VM's Hostname
$username = "Username" # <-- Replace with your VM's Username (yes, this is not very secure), needs improvement
$password = "Password" # <-- Replace with your VM's Password (yes, I know)

# RDP Details
$resolutionWidth = "1420"
$resolutionHeight = "1240"

# Tunnel Details
$tunnelSSHPort = "22"
$socksPort = "8081"

function Start-Firefox {
    $urls = @( # Replace the URLs below with what you need. See next comment further as values also need to be changed
        "https://duckduckgo.com",
        "https://github.com",
        "https://stackoverflow.com",
        "https://stackexchange.com/sites#technology"
    )

    $firefoxCommand = "C:\Program Files\Mozilla Firefox\firefox.exe"  # <--- Replace with your FF Directory
    $firefoxArguments = ($urls -join ' ')

    Start-Process -FilePath $firefoxCommand -ArgumentList $firefoxArguments; Start-Sleep -Seconds 2

    # Using $wshell.SendKeys to send ALT+P to pin tabs and CTRL+PGDN to move to the next tab 
    # in a loop until all of the tabs I want are pinned
    # Requires the FF Extension "Pin Unpin Tab" https://addons.mozilla.org/en-US/firefox/addon/pinunpin-tab/
    $wshell = New-Object -ComObject wscript.shell
    1..4 | ForEach-Object {     # Replace second value in 1..4 corresponding to how many tabs need to be pinned
        $wshell.SendKeys('%{p}')
        Start-Sleep -Milliseconds 500
        $wshell.SendKeys('^{PGDN}')
    }
}

function Start-HyperV {
    Start-VM -Name $vm
        while((Get-VM -Name $vm).HeartBeat -ne  'OkApplicationsUnknown')
        {
            Start-Sleep -Seconds 1
            "$vm is not ready. Waiting for HeartBeat"
        }
    "$vm ready."; Start-Sleep -s 2
}
function Open-RDP {
    mstsc.exe /v:"$hostname" /admin /w:"$resolutionWidth" /h:"$resolutionHeight"; Start-Sleep -s 2
    
    $wshell = New-Object -ComObject wscript.shell
        $wshell.SendKeys($password)
        $wshell.SendKeys('{ENTER}')     
}

function Open-Tunnel {
    Start-Process powershell -ArgumentList "-NoExit", "-Command ssh -vv -p $tunnelSSHport -D $socksPort $username@$hostname"
}

function start-Proxy {
    $proxyRegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    $proxyServer = "socks=localhost:$socksPort"
    Set-ItemProperty -Path $proxyRegKey ProxyEnable -Value 1 -ErrorAction Stop
    Set-ItemProperty -Path $proxyRegKey ProxyServer -Value $proxyServer -ErrorAction Stop

    Write-Host "Proxy is now enabled" -ForegroundColor Yellow
}

function Start-Edge {
    ## Function to start Edge instead of Firefox. Leaving this here and can call it from start-work.ps1 if wanted. 👎

    $edgeCommand = "msedge.exe"
    $edgeArguments = "--restore-last-session"

    Start-Process -FilePath $edgeCommand -ArgumentList $edgeArguments; Start-Sleep -Seconds 2
}

function Stop-Work {
    Stop-Process -Name "firefox" -PassThru
    
    $proxyRegKey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
    Set-ItemProperty -Path $proxyRegKey ProxyEnable -Value 0 -ErrorAction Stop
    "Tunnel is stopped and Proxy is now disabled"

    Stop-VM -Name $vm
    while((Get-VM -Name $vm).State -ne 'Off')
    {
        Start-Sleep -Seconds 1
        "$vm is not yet stopped. Waiting for the VM to be in the 'Off' state."
    }
    "$vm has been stopped."
    ""
    ""
    "Have a nice day!" 
    
}