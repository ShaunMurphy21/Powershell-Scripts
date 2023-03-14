Connect-MsolService

Write-Host " ___       ___  _________  _________  ___       _______   ________ ___  ________  ___  ___     "-ForegroundColor Magenta; 
Write-Host "|\  \     |\  \|\___   ___\\___   ___\\  \     |\  ___ \ |\  _____\\  \|\   ____\|\  \|\  \    "-ForegroundColor Blue;
Write-Host "\ \  \    \ \  \|___ \  \_\|___ \  \_\ \  \    \ \   __/|\ \  \__/\ \  \ \  \___|\ \  \\\  \   "-ForegroundColor DarkRed;
Write-Host " \ \  \    \ \  \   \ \  \     \ \  \ \ \  \    \ \  \_|/_\ \   __\\ \  \ \_____  \ \   __  \  "-ForegroundColor Green; 
Write-Host "  \ \  \____\ \  \   \ \  \     \ \  \ \ \  \____\ \  \_|\ \ \  \_| \ \  \|____|\  \ \  \ \  \ "-ForegroundColor Yellow;
Write-Host "   \ \_______\ \__\   \ \__\     \ \__\ \ \_______\ \_______\ \__\   \ \__\____\_\  \ \__\ \__\"-ForegroundColor DarkGreen;
Write-Host "    \|_______|\|__|    \|__|      \|__|  \|_______|\|_______|\|__|    \|__|\_________\|__|\|__|"-ForegroundColor Cyan;
Write-Host "                                                                          \|_________|         "-ForegroundColor Magenta;
Write-Host "                                                                                               "-ForegroundColor DarkYello;
Write-Host "                                                                                               "-ForegroundColor Magenta;



function MainProg{

    $email = Read-Host "Enter users email"

    $license = "Ofsted365:M365EDU_A5_FACULTY"

    $DisabledApps=@()
    $DisabledApps+="INFORMATION_BARRIERS"
    $DisabledApps+="KAIZALA_STANDALONE"
    $DisabledApps+="PREMIUM_ENCRYPTION"
    $DisabledApps+="PAM_ENTERPRISE"
    $DisabledApps+="ATA"
    $DisabledApps+="INTUNE_EDU"
    $DisabledApps+="MICROSOFTBOOKINGS"
    $DisabledApps+="MINECRAFT_EDUCATION_EDITION"
    $DisabledApps+="MFA_PREMIUM"
    $DisabledApps+="WINDEFATP"
    $DisabledApps+="LOCKBOX_ENTERPRISE"
    $DisabledApps+="AAD_BASIC_EDU"
    
    $DisabledApps

    $E5_DefaultApps = New-MsolLicenseOptions -AccountSkuID $license -DisabledPlans $DisabledApps
    Set-MsolUser -UserPrincipalName ($email -replace '"') -UsageLocation GB

    Set-MsolUserLicense -UserPrincipalName ($email -replace '"') -AddLicenses $license
    Write-Output "Made the license"
    Set-MsolUserLicense -UserPrincipalName ($email -replace '"') -LicenseOptions $E5_DefaultApps
    (Get-MsolUser -UserPrincipalName ($email -replace '"')).Licenses.ServiceStatus | Where-Object ProvisioningStatus -eq 'Disabled';(Get-MsolUser -UserPrincipalName ($email -replace '"')).Licenses | Select-Object AccountSkuID

    $con = Read-Host "Assigned the license - press enter to go again or enter y to exit"

    if($con -eq ''){
    
        MainProg
    }
    else{
        Write-Host 'Exiting'
    }

}

MainProg





