Connect-MsolService


function MainProg{

    $email = Read-Host "Enter users email"

    $license = "M365EDU_A5_FACULTY"

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





