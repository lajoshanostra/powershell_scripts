## PowerShell Scripts for Work Environment Automation

This repository contains PowerShell scripts designed to automate the setup and teardown of a work environment. The scripts utilize various functions stored in `functions-work.ps1`.

### Usage:

1. Edit the values in `functions-work.ps1` to match your environment.
2. Run `start-work.ps1` to set up your work environment.
3. Run `stop-work.ps1` to tear down the work environment.

### `functions-work.ps1`

This script serves as a function library for `start-work.ps1` and `stop-work.ps1`. Before using the main scripts, ensure that you replace placeholder values in the script to match your specific environment. Key variables to update include:

- Hyper-V VM details (`$vm`, `$hostname`, `$username`, `$password`)
- RDP Details (`$resolutionWidth`, `$resolutionHeight`)
- Tunnel Details (`$tunnelSSHPort`, `$socksPort`)
- Firefox URLs (`$urls`), and number of tabs in the loop (`1..X`)

#### Functions:

1. **Start-Firefox:**
   - Launches Mozilla Firefox with specified URLs, pins tabs, and ensures they are loaded.

2. **Start-HyperV:**
   - Initiates the specified Hyper-V VM, waiting for its HeartBeat to indicate readiness.

3. **Open-RDP:**
   - Opens a Remote Desktop session to the specified host with defined resolution settings.

4. **Open-Tunnel:**
   - Initiates an SSH tunnel to the specified host with defined SSH port and SOCKS port.

5. **start-Proxy:**
   - Enables a proxy using Windows registry settings with the specified SOCKS port.

6. **Start-Edge:**
   - (Optional) Function to start Microsoft Edge; can be called from `start-work.ps1`.

7. **Stop-Work:**
   - Terminates Firefox, disables the proxy, stops the Hyper-V VM, and waits for the VM to be in the 'Off' state.

### `start-work.ps1`

This script automates the setup of a work environment. It includes the following steps:

1. Check for admin privileges and elevate if necessary.
2. Import functions from `functions-work.ps1`.
3. Start the Hyper-V VM.
4. Open an RDP session to the VM.
5. Open an SSH tunnel and configure proxy settings.
6. Wait for SSH login and then start Mozilla Firefox.

### `stop-work.ps1`

This script automates the teardown of the work environment. It performs the following actions:

1. Check for admin privileges and elevate if necessary.
2. Import functions from `functions-work.ps1`.
3. Stop Mozilla Firefox.
4. Disable the proxy.
5. Stop the Hyper-V VM and wait for it to reach the 'Off' state.