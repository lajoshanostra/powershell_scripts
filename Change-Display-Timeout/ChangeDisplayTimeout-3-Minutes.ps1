# Define the desired timeout value in minutes
$timeoutInMinutes = 3

# Set the "Turn off display" setting using the powercfg command
powercfg -change monitor-timeout-ac $timeoutInMinutes
powercfg -change monitor-timeout-dc $timeoutInMinutes