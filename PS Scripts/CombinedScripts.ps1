Add-Type -AssemblyName PresentationCore,PresentationFramework

Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);'

[Console.Window]::ShowWindow([Console.Window]::GetConsoleWindow(), 0)

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

function InfoForm( $msgBody){

    [System.Windows.MessageBox]::Show($msgBody)

}


$UserCredOP = Get-Credential
$SessionOP = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri connectionUrl -Authentication Kerberos -Credential $UserCredOP
Import-PSSession $SessionOP -allowclobber

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,111)
$Form.text                       = "Littlefish - Scripts"
$Form.TopMost                    = $false


$emailLabel                      = New-Object system.Windows.Forms.Label
$emailLabel.text                 = "Email:"
$emailLabel.AutoSize             = $true
$emailLabel.width                = 25
$emailLabel.height               = 10
$emailLabel.location             = New-Object System.Drawing.Point(11,26)
$emailLabel.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',12,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 175
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(78,23)
$TextBox1.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$upnCheck                        = New-Object system.Windows.Forms.CheckBox
$upnCheck.text                   = "Change UPN?"
$upnCheck.AutoSize               = $false
$upnCheck.width                  = 180
$upnCheck.height                 = 20
$upnCheck.location               = New-Object System.Drawing.Point(77,49)
$upnCheck.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$mailboxCheck                    = New-Object system.Windows.Forms.CheckBox
$mailboxCheck.text               = "Migrate Mailbox?"
$mailboxCheck.AutoSize           = $false
$mailboxCheck.width              = 180
$mailboxCheck.height             = 20
$mailboxCheck.location           = New-Object System.Drawing.Point(77,73)
$mailboxCheck.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$assignButton                    = New-Object system.Windows.Forms.Button
$assignButton.text               = "Assign Licenses?"
$assignButton.width              = 113
$assignButton.height             = 76
$assignButton.location           = New-Object System.Drawing.Point(265,20)
$assignButton.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',9)

$Form.controls.AddRange(@($emailLabel,$TextBox1,$upnCheck,$mailboxCheck,$assignButton))


$assignButton.Add_Click({
    try{

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
    Set-MsolUser -UserPrincipalName ($TextBox1.Text -replace '"') -UsageLocation GB
    Set-MsolUserLicense -UserPrincipalName ($TextBox1.Text -replace '"') -AddLicenses $license
    Set-MsolUserLicense -UserPrincipalName ($TextBox1.Text -replace '"') -LicenseOptions $E5_DefaultApps
    }
    catch{
    
        InfoForm "Error Assigning Licenses, use old script or do manually."

    }

    if($upnCheck.Checked){

    try{
        $user = Get-ADUser -Filter {userprincipalname -eq $TextBox1.Text} | select samaccountname
        $name = Get-ADUser -Identity $user.samaccountname | select GivenName, Surname
        $newUPN = $name.GivenName + '.' + $name.Surname +'@domain'
        $newUPN = $newUPN.replace("'","")

        Set-ADUser -Identity $user.samaccountname -UserPrincipalName $newUPN
        Set-ADUser -Identity $user.samaccountname -EmailAddress $newUPN
        Start-Sleep -Seconds 1
        }
        catch{
            InfoForm "Error Changing UPN, do manually"
        }
    }
    if($mailboxCheck.Checked){

       try{

        Get-ADUser -Identity $user.samaccountname | Move-ADObject -TargetPath "OU"
        Set-User -Identity $user.samaccountname -fax "LTA"
        Set-ADUser -Identity $user.samaccountname -Enable:$true
        Start-Sleep -Seconds 5
        $MB1 = Get-ADUser $user.samaccountname
        $MB3 = $MB1.UserPrincipalName
        $MB4 = $MB1.SamAccountName + '@routing'

        Enable-RemoteMailbox -Identity $MB3 -RemoteRoutingAddress $MB4
        Start-Sleep -Seconds 1
        
        }
        catch{
            InfoForm "Error Migrating Mailbox, Use old script."
        }
    }

    InfoForm "Actions Completed."
    
})


[void]$Form.ShowDialog()
