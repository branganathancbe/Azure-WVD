
##############################
#    WVD Script Parameters   #
##############################
<#Param (        
    [Parameter(Mandatory=$true)]
        [string]$RegistrationToken<#,
    [Parameter(Mandatory=$false)]
        [string]$Optimize = $true#>           
#>

#Download and Import Modules
install-packageProvider -Name NuGet -MinimumVErsion 2.8.5.201 -force
Install-Module -Name Az.DesktopVirtualization -AllowClobber -Force
Set-ExecutionPolicy -ExecutionPolicy Bypass -force
Import-Module -Name Az.DesktopVirtualization

######################
#    WVD Variables   #
######################
$RegistrationToken = "eyJhbGciOiJSUzI1NiIsImtpZCI6IkZDMTBFOUQzNUQ4MEFCMjQyMTM2MTJBMDIwQjA3Q0U2Q0UxODRGMDAiLCJ0eXAiOiJKV1QifQ.eyJSZWdpc3RyYXRpb25JZCI6ImVkNTc0YTlhLTI5Y2ItNDYzNi1hMjM1LTdlODRkMjE5ZDdlZSIsIkJyb2tlclVyaSI6Imh0dHBzOi8vcmRicm9rZXItZy11cy1yMC53dmQubWljcm9zb2Z0LmNvbS8iLCJEaWFnbm9zdGljc1VyaSI6Imh0dHBzOi8vcmRkaWFnbm9zdGljcy1nLXVzLXIwLnd2ZC5taWNyb3NvZnQuY29tLyIsIkVuZHBvaW50UG9vbElkIjoiNzkzMDFiNTctZWM2Zi00N2ViLWJiN2MtZmM0MDExYjdhOTdmIiwiR2xvYmFsQnJva2VyVXJpIjoiaHR0cHM6Ly9yZGJyb2tlci53dmQubWljcm9zb2Z0LmNvbS8iLCJHZW9ncmFwaHkiOiJVUyIsIkdsb2JhbEJyb2tlclJlc291cmNlSWRVcmkiOiJodHRwczovL3JkYnJva2VyLnd2ZC5taWNyb3NvZnQuY29tLyIsIkJyb2tlclJlc291cmNlSWRVcmkiOiJodHRwczovL3JkYnJva2VyLWctdXMtcjAud3ZkLm1pY3Jvc29mdC5jb20vIiwiRGlhZ25vc3RpY3NSZXNvdXJjZUlkVXJpIjoiaHR0cHM6Ly9yZGRpYWdub3N0aWNzLWctdXMtcjAud3ZkLm1pY3Jvc29mdC5jb20vIiwibmJmIjoxNjQzMzQyODAyLCJleHAiOjE2NDM5NDc2MDIsImlzcyI6IlJESW5mcmFUb2tlbk1hbmFnZXIiLCJhdWQiOiJSRG1pIn0.CNpmY47JnjyjqmljUN24jejdyZoTgSbKZD68wN4KSiWUl858A5luFOhXUxc_gEKBZLZ00su8XF3G0JtJzW9PwDw-LIy7b_WmvxcNeET4TEsg1qwigE6_hPawhu0aywW2nkQ0twuj4wtOg-txKU4n6Uxd9O_iiteVxrs4DCJsAgDxLhYHXNdKBPVx3knnlb-H1ijhKqPZlXOhs2pm1cdvsOON8p_lz1nzoY-IYwXFjgGsfrhRCoa3YE9kzE4JZQI1lQpNzUMdRvYHAwcU9qFID8_ZVEk6fRd1v4w1ioSNpZfuQkXa1QlILnHj5RaNRhFmUClShlaIrB3wmQe7uk-14Q"
$LocalWVDpath            = "c:\temp\wvd\"
$WVDBootURI              = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrxrH'
$WVDAgentURI             = 'https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWrmXv'
$WVDAgentInstaller       = 'WVD-Agent.msi'
$WVDBootInstaller        = 'WVD-Bootloader.msi'
$Optimizations           = "All"


####################################
#    Test/Create Temp Directory    #
####################################
if((Test-Path c:\temp) -eq $false) {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Create C:\temp Directory"
    Write-Host `
        -ForegroundColor Cyan `
        -BackgroundColor Black `
        "creating temp directory"
    New-Item -Path c:\temp -ItemType Directory
}
else {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "C:\temp Already Exists"
    Write-Host `
        -ForegroundColor Yellow `
        -BackgroundColor Black `
        "temp directory already exists"
}
if((Test-Path $LocalWVDpath) -eq $false) {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Create C:\temp\WVD Directory"
    Write-Host `
        -ForegroundColor Cyan `
        -BackgroundColor Black `
        "creating c:\temp\wvd directory"
    New-Item -Path $LocalWVDpath -ItemType Directory
}
else {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "C:\temp\WVD Already Exists"
    Write-Host `
        -ForegroundColor Yellow `
        -BackgroundColor Black `
        "c:\temp\wvd directory already exists"
}
<#New-Item -Path c:\ -Name New-WVDSessionHost.log -ItemType File
Add-Content `
-LiteralPath C:\New-WVDSessionHost.log `#>
"
RegistrationToken = $RegistrationToken"
#Optimize          = $Optimize



#################################
#    Download WVD Componants    #
#################################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Downloading WVD Boot Loader"
    Invoke-WebRequest -Uri $WVDBootURI -OutFile "$LocalWVDpath$WVDBootInstaller"
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Downloading WVD Agent"
    Invoke-WebRequest -Uri $WVDAgentURI -OutFile "$LocalWVDpath$WVDAgentInstaller"

<#
##############################
#    OS Specific Settings    #
##############################
$OS = (Get-WmiObject win32_operatingsystem).name
If(($OS) -match 'server') {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Windows Server OS Detected"
    write-host -ForegroundColor Cyan -BackgroundColor Black "Windows Server OS Detected"
    If(((Get-WindowsFeature -Name RDS-RD-Server).installstate) -eq 'Installed') {
        "Session Host Role is already installed"
    }
    Else {
        "Installing Session Host Role"
        Install-WindowsFeature `
            -Name RDS-RD-Server `
            -Verbose `
            -LogPath "$LocalWVDpath\RdsServerRoleInstall.txt"
    }
    $AdminsKey = "SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
    $UsersKey = "SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}"
    $BaseKey = [Microsoft.Win32.RegistryKey]::OpenBaseKey("LocalMachine","Default")
    $SubKey = $BaseKey.OpenSubkey($AdminsKey,$true)
    $SubKey.SetValue("IsInstalled",0,[Microsoft.Win32.RegistryValueKind]::DWORD)
    $SubKey = $BaseKey.OpenSubKey($UsersKey,$true)
    $SubKey.SetValue("IsInstalled",0,[Microsoft.Win32.RegistryValueKind]::DWORD)    
}
Else {
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Windows Client OS Detected"
    write-host -ForegroundColor Cyan -BackgroundColor Black "Windows Client OS Detected"
    if(($OS) -match 'Windows 10') {
        write-host `
            -ForegroundColor Yellow `
            -BackgroundColor Black  `
            "Windows 10 detected...skipping to next step"
        Add-Content -LiteralPath C:\New-WVDSessionHost.log "Windows 10 Detected...skipping to next step"     
    }    
    else {
        $OSArch = (Get-WmiObject win32_operatingsystem).OSArchitecture
        If(($OSArch) -match '64-bit') {
            write-host `
                -ForegroundColor Magenta  `
                -BackgroundColor Black `
                "Windows 7 x64 detected"
            Add-Content -LiteralPath C:\New-WVDSessionHost.log "Windows 7 x64 Detected"


        }        
    }
}
#>

################################
#    Install WVD Componants    #
################################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Installing WVD Bootloader"
$bootloader_deploy_status = Start-Process `
    -FilePath "msiexec.exe" `
    -ArgumentList "/i $WVDBootInstaller", `
        "/quiet", `
        "/qn", `
        "/norestart", `
        "/passive", `
        "/l* $LocalWVDpath\AgentBootLoaderInstall.txt" `
    -Wait `
    -Passthru
$sts = $bootloader_deploy_status.ExitCode
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Installing WVD Bootloader Complete"
Write-Output "Installing RDAgentBootLoader on VM Complete. Exit code=$sts`n"
Wait-Event -Timeout 5

Add-Content -LiteralPath C:\New-WVDSessionHost.log "Installing WVD Agent"
Write-Output "Installing RD Infra Agent on VM $AgentInstaller`n"
$agent_deploy_status = Start-Process `
    -FilePath "msiexec.exe" `
    -ArgumentList "/i $WVDAgentInstaller", `
        "/quiet", `
        "/qn", `
        "/norestart", `
        "/passive", `
        "REGISTRATIONTOKEN=$RegistrationToken", "/l* $LocalWVDpath\AgentInstall.txt" `
    -Wait `
    -Passthru
Add-Content -LiteralPath C:\New-WVDSessionHost.log "WVD Agent Install Complete"
Wait-Event -Timeout 5


##########################################
#    Enable Screen Capture Protection    #
##########################################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Enable Screen Capture Protection"
Push-Location 
Set-Location "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
New-ItemProperty `
    -Path .\ `
    -Name fEnableScreenCaptureProtection `
    -Value "1" `
    -PropertyType DWord `
    -Force
Pop-Location


##############################
#    Enable Azure AD Join    #
##############################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Enable Azure AD Join"
Push-Location 
Set-Location HKLM:\SOFTWARE\Microsoft
New-Item `
    -Path HKLM:\SOFTWARE\Microsoft `
    -Name RDInfraAgent `
    -Force
New-Item `
    -Path HKLM:\Software\Microsoft\RDInfraAgent `
    -Name AADJPrivate `
    -Force
Pop-Location

<#
##############################################
#    WVD Optimizer (Virtual Desktop Team)    #
##############################################
If ($Optimize -eq $true) {  
    Write-Output "Optimizer selected"  
    ################################
    #    Download WVD Optimizer    #
    ################################
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Optimize Selected"
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Creating C:\Optimize folder"
    New-Item -Path C:\ -Name Optimize -ItemType Directory -ErrorAction SilentlyContinue
    $LocalPath = "C:\Optimize\"
    $WVDOptimizeURL = 'https://github.com/The-Virtual-Desktop-Team/Virtual-Desktop-Optimization-Tool/archive/refs/heads/main.zip'
    $WVDOptimizeInstaller = "Windows_10_VDI_Optimize-master.zip"
    Invoke-WebRequest `
        -Uri $WVDOptimizeURL `
        -OutFile "$Localpath$WVDOptimizeInstaller"


    ###############################
    #    Prep for WVD Optimize    #
    ###############################
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Optimize downloaded and extracted"
    Expand-Archive `
        -LiteralPath "C:\Optimize\Windows_10_VDI_Optimize-master.zip" `
        -DestinationPath "$Localpath" `
        -Force `
        -Verbose



    #################################
    #    Run WVD Optimize Script    #
    #################################
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Begining Optimize"
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force -Verbose
    .\Win10_VirtualDesktop_Optimize.ps1 -Optimizations $Optimizations -Restart -AcceptEULA -Verbose
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Optimization Complete"
}
else {
    Write-Output "Optimize not selected"
    Add-Content -LiteralPath C:\New-WVDSessionHost.log "Optimize NOT selected"    
}
#>

##########################
#    Restart Computer    #
##########################
Add-Content -LiteralPath C:\New-WVDSessionHost.log "Process Complete - REBOOT"
Restart-Computer -Force 
