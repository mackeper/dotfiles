dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# https://docs.microsoft.com/en-us/windows/wsl/install-win10

wsl --install
wsl --set-default-version 2