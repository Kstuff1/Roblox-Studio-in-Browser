# 1. Download the latest Roblox Studio Installer
$installerPath = "$env:TEMP\RobloxStudioLauncherBeta.exe"
Invoke-WebRequest -Uri "https://rbxcdn.com" -OutFile $installerPath

# 2. Install Roblox Studio silently
# Using --silent avoids UI prompts during installation
Start-Process -FilePath $installerPath -ArgumentList "--silent" -Wait

# 3. Find the dynamic installation path
# Roblox installs to a versioned folder in AppData
$studioPath = Get-ChildItem -Path "$env:LOCALAPPDATA\Roblox\Versions" -Filter "RobloxStudioBeta.exe" -Recurse | Select-Object -ExpandProperty FullName -First 1

if ($studioPath) {
    # 4. Replace Windows Explorer with Roblox Studio (Kiosk Mode)
    # This modifies the registry so only Studio opens on boot, hiding the desktop UI
    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
    Set-ItemProperty -Path $registryPath -Name "Shell" -Value $studioPath
    
    # 5. Launch Studio immediately for the current session
    Start-Process -FilePath $studioPath
} else {
    Write-Host "Roblox Studio installation failed or path not found."
}
