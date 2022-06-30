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

####################################################################################################################################################

# Define URLs to open in Firefox
$url1 = ""
$ulr2 = ""
$url3 = ""
$url4 = ""
$url5 = ""
$url6 = ""
$url7 = ""

# Define Hyper-V VM details
$vm = ""
$hostname = ""
$password = ""

####################################################################################################################################################


function Start-Firefox {
    Start-Process -FilePath Firefox -ArgumentList $url1, $url2, $url3, $url4, $url5, $url6, $url7; Start-Sleep -s 10        
    $wshell = New-Object -ComObject wscript.shell
        1..7 | % {
        $wshell.SendKeys('%{p}')
        Start-Sleep -m 100
        $wshell.SendKeys('^{PGDN}')
        }
}

Start-Firefox

function Start-HyperV 
{
    Start-VM -Name $vm
        while((Get-VM -Name $vm).HeartBeat -ne  'OkApplicationsUnknown')
        {
            Start-Sleep -Seconds 1
            "$vm is not ready. Waiting for HeartBeat"
        }
    "$vm ready. Opening RDP"; Start-Sleep -s 2    
}       

Start-HyperV 

function Open-RDP
{
    mstsc.exe /v:$hostname /admin /w:1740 /h:1310; Start-Sleep -s 2
    
    $wshell = New-Object -ComObject wscript.shell
        $wshell.SendKeys($password)
        $wshell.SendKeys('{ENTER}')     

    Start-Sleep -Seconds 3
}

Open-RDP

stop-process -Id $PID