﻿Add-Type -AssemblyName PresentationCore,PresentationFramework
<# 
.NAME
    NewStart
#>


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




$gammaEmail = @'

Hi,

Could you please {0} {1} for user {2} ; {3}

Thanks,



'@

$hashLocation = @{officeLocations}

$hmi_scri = @('')
$eyri = @('')
$director = @('')
$bi_it = @('')
$hybrid = @('')
$office = @('')
$Contractor = @('')

$boxxeEmail = @'
Email for formatting goes here

'@



$Form2                            = New-Object system.Windows.Forms.Form
$Form2.ClientSize                 = New-Object System.Drawing.Point(670,700)
$Form2.text                       = "Form"
$Form2.TopMost                    = $true
$Form2.BackgroundImage            = $img



$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(670,700)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$Groupbox1                       = New-Object system.Windows.Forms.Groupbox
$Groupbox1.height                = 130
$Groupbox1.width                 = 200
$Groupbox1.text                  = "Licenses"
$Groupbox1.location              = New-Object System.Drawing.Point(229,9)

$Groupbox2                       = New-Object system.Windows.Forms.Groupbox
$Groupbox2.height                = 226
$Groupbox2.width                 = 226
$Groupbox2.text                  = "Softbox Build"
$Groupbox2.location              = New-Object System.Drawing.Point(435,8)

$Groupbox3                       = New-Object system.Windows.Forms.Groupbox
$Groupbox3.height                = 88
$Groupbox3.width                 = 200
$Groupbox3.text                  = "Number"
$Groupbox3.location              = New-Object System.Drawing.Point(229,146)

$ErrorProvider1                  = New-Object system.Windows.Forms.ErrorProvider

$samName                         = New-Object system.Windows.Forms.TextBox
$samName.multiline               = $false
$samName.width                   = 145
$samName.height                  = 20
$samName.location                = New-Object System.Drawing.Point(74,18)
$samName.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Username:"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(8,22)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',8)

$phoneNumber                     = New-Object system.Windows.Forms.TextBox
$phoneNumber.multiline           = $false
$phoneNumber.width               = 178
$phoneNumber.height              = 20
$phoneNumber.location            = New-Object System.Drawing.Point(5,21)
$phoneNumber.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$numberButton                    = New-Object system.Windows.Forms.Button
$numberButton.text               = "OK"
$numberButton.width              = 60
$numberButton.height             = 30
$numberButton.location           = New-Object System.Drawing.Point(6,52)
$numberButton.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$numberButton.Add_Click({
    if($phoneNumber.Text -ne ''){
    $user = Get-ADUser -Identity $samName.Text
    $gammaEmail = $gammaEmail -f 'assign', $phoneNumber.Text, $user.Name, $user.userprincipalname
    $emailBox.Text = $gammaEmail
    Set-ADUser $user -OfficePhone $phoneNumber.Text
    }
    else{
    
        $user = Get-ADUser -Identity $samName.Text -Properties *
        $gammaEmail = $gammaEmail -f 'unassign', $user.OfficePhone, $user.Name, $user.userprincipalname
        Set-ADUser $user -OfficePhone $null
        $emailBox.Text = $gammaEmail

    
    }
})

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Assign Licenses"
$Button1.width                   = 154
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(5,92)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$checkAccount                         = New-Object system.Windows.Forms.Button
$checkAccount.text                    = "Check Account"
$checkAccount.width                   = 148
$checkAccount.height                  = 30
$checkAccount.location                = New-Object System.Drawing.Point(73,50)
$checkAccount.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$checkAccount.Add_Click({

    $check = Get-ADUser $samName.Text -Properties * | select lockedout, passwordexpired
    $emailBox.Text = $check | format-list | out-string

    if($unlock.Checked){
        
        Unlock-ADAccount -Identity $samName.Text
        $check = $check | select lockedout | format-list | out-string
        $emailBox.Text = $emailBox.Text + "Account Has been Unlocked:" + $check
    
    }

})


$unlock                       = New-Object system.Windows.Forms.CheckBox
$unlock.text                   = "Unlock if locked"
$unlock.AutoSize               = $false
$unlock.width                  = 166
$unlock.height                 = 20
$unlock.location               = New-Object System.Drawing.Point(73,80)
$unlock.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


$password                         = New-Object system.Windows.Forms.Button
$password.text                    = "Reset Password"
$password.width                   = 148
$password.height                  = 30
$password.location                = New-Object System.Drawing.Point(73,100)
$password.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$password.Add_Click({

    $month = Get-Date -Format "MM"
    $month = [int]$month

    $month = switch($month)
    
    {

#passwordsHere


    }
    Set-ADAccountPassword -Identity $samName.Text -NewPassword (ConvertTo-SecureString -AsPlainText $month -Force)

    $emailbox.Text = 'Password Set to:' + $month
    
})

$Button1.Add_Click({

$user = Get-ADUser -Identity $samName.Text -Properties *

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
    Set-MsolUser -UserPrincipalName ($user.userprincipalname) -UsageLocation GB
    Set-MsolUserLicense -UserPrincipalName ($user.userprincipalname) -AddLicenses $license
    Set-MsolUserLicense -UserPrincipalName ($user.userprincipalname) -LicenseOptions $E5_DefaultApps
    $license = Get-MsolUser -UserPrincipalName $user.userprincipalname | select Licenses
    $emailBox.Text = 'Licenses assigned succesfully!' + $license
    }
    
    catch{
    
     
    }

    if($upnCheck.Checked){

    try{
        $user = Get-ADUser -Identity $samName.Text
        $name = $user | select GivenName, Surname
        $newUPN = $name.GivenName + '.' + $name.Surname +'@domain'
        $newUPN = $newUPN.replace("'","")

        Set-ADUser -Identity $user -UserPrincipalName $newUPN
        Set-ADUser -Identity $user -EmailAddress $newUPN
        $emailBox.Text = $emailBox.Text + 'UPN Changed'
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
        Start-Sleep -Seconds 1
        $MB1 = Get-ADUser $user.samaccountname
        $MB3 = $MB1.UserPrincipalName
        $MB4 = $MB1.SamAccountName + '@routing'

        Enable-RemoteMailbox -Identity $MB3 -RemoteRoutingAddress $MB4
        Start-Sleep -Seconds 1
        $emailBox.Text = $emailBox.Text + 'Mailbox Migrated'
        
        }
        catch{
            InfoForm "Error Migrating Mailbox, Use old script."
        }
    }


})

$upnCheck                        = New-Object system.Windows.Forms.CheckBox
$upnCheck.text                   = "Change UPN"
$upnCheck.AutoSize               = $false
$upnCheck.width                  = 166
$upnCheck.height                 = 20
$upnCheck.location               = New-Object System.Drawing.Point(9,26)
$upnCheck.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$mailboxCheck                    = New-Object system.Windows.Forms.CheckBox
$mailboxCheck.text               = "Migrate Mailbox"
$mailboxCheck.AutoSize           = $false
$mailboxCheck.width              = 181
$mailboxCheck.height             = 20
$mailboxCheck.location           = New-Object System.Drawing.Point(10,56)
$mailboxCheck.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ProgressBar = New-Object System.Windows.Forms.ProgressBar
$ProgressBar.Width = 640
$ProgressBar.Height = 25
$ProgressBar.Visible = $True
$ProgressBar.Minimum = $MinMax.Minimum
$ProgressBar.Maximum = $MinMax.Maximum
$ProgressBar.Value = $MinMax.Minimum
$ProgressBar.Step = 1
$ProgressBar.Location = New-Object System.Drawing.Point(10,650)
$Form.Controls.Add($ProgressBar)

$roleBox                         = New-Object system.Windows.Forms.ComboBox
$roleBox.width                   = 134
$roleBox.height                  = 20
$roleBox.location                = New-Object System.Drawing.Point(74,22)
@('') | ForEach-Object {[void] $roleBox.Items.Add($_)}
$roleBox.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$officeBox                       = New-Object system.Windows.Forms.ComboBox
$officeBox.width                 = 135
$officeBox.height                = 20
$officeBox.location              = New-Object System.Drawing.Point(73,59)
@('') | ForEach-Object {[void] $officeBox.Items.Add($_)}
$officeBox.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$dateBox                         = New-Object system.Windows.Forms.TextBox
$dateBox.multiline               = $false
$dateBox.width                   = 136
$dateBox.height                  = 20
$dateBox.location                = New-Object System.Drawing.Point(73,99)
$dateBox.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$boxxeButton                     = New-Object system.Windows.Forms.Button
$boxxeButton.text                = "Push to Box"
$boxxeButton.width               = 117
$boxxeButton.height              = 30
$boxxeButton.location            = New-Object System.Drawing.Point(8,188)
$boxxeButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$boxxeButton.Add_Click({
 
    if($roleBox.SelectedItem -eq ''){$a = $hmi_scri}
    if($roleBox.SelectedItem -eq ''){$a = $eyri}
    if($roleBox.SelectedItem -eq ''){$a = $director}
    if($roleBox.SelectedItem -eq ''){$a = $bi_it}
    if($roleBox.SelectedItem -eq ''){$a = $hybrid}
    if($roleBox.SelectedItem -eq ''){$a = $office}
    if($roleBox.SelectedItem -eq ''){$a = $Contractor}

    $user = Get-ADUser -Identity $samName.Text -Properties *
    $new = Get-ADUser -Identity $user.Manager -Properties * | select Name
    $manPhone = Get-ADUser -Identity $user.Manager -Properties * | select -ExpandProperty OfficePhone
    $b = Get-Date -Format "MM/yyyy"
    $boxxeEmail = $boxxeEmail -f $user.Name,$role.SelectedItem,$a[1],$a[0],$user.SamAccountName,$b,$user.UserPrincipalName,$dateBox.Text,$manPhone,$hashLocation.($officeBox.SelectedItem)

    $emailBox.Text = $boxxeEmail
})

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Role:"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(9,24)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "Office:"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(5,64)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.text                     = "Date:"
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(9,106)
$Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$emailBox                        = New-Object system.Windows.Forms.TextBox
$emailBox.multiline              = $true
$emailBox.width                  = 650
$emailBox.height                 = 350
$emailBox.location               = New-Object System.Drawing.Point(8,243)
$emailBox.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


$loginButton                     = New-Object system.Windows.Forms.Button
$loginButton.text                = "Log In"
$loginButton.width               = 213
$loginButton.height              = 70
$loginButton.location            = New-Object System.Drawing.Point(8,160)
$loginButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',15)

$nasapic                         = New-Object system.Windows.Forms.Button
$nasapic.text                    = "NASA API"
$nasapic.width                   = 148
$nasapic.height                  = 30
$nasapic.location                = New-Object System.Drawing.Point(10,600)
$nasapic.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$nasapic.Add_Click({
    $picday = 'https://api.nasa.gov/planetary/apod?api_key=DpEmA8XVdmQ24jW1hwjbnpyNvnZrVwyfksvcSlRt
'
    $pic = Invoke-RestMethod $picday

iwr $pic.url -OutFile "~\Documents\nasa.jpg"
$file = (get-item '~\Documents\nasa.jpg')
$img = [System.Drawing.Image]::FromFile($file)

    $Form2.ShowDialog()

})

$weth                        = New-Object system.Windows.Forms.Button
$weth.text                    = "Weather Forecast API"
$weth.width                   = 148
$weth.height                  = 30
$weth.location                = New-Object System.Drawing.Point(170,600)
$weth.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$weth.Add_Click({
    $apiUrl = 'https://api.open-meteo.com/v1/forecast?latitude=52.952152&longitude=-1.142590&current_weather=true'
    $weather = Invoke-RestMethod $apiUrl

    $weather = 'The temperature is: ' + $weather.current_weather.temperature

    InfoForm $weather

})

$groupReport                        = New-Object system.Windows.Forms.Button
$groupReport.text                    = "Restricted Report"
$groupReport.width                   = 148
$groupReport.height                  = 30
$groupReport.location                = New-Object System.Drawing.Point(330,600)
$groupReport.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$groupReport.Add_Click({
        try{
        foreach($grp in $groupList){
    
     Get-ADGroupMember -Identity $grp -Recursive | Get-ADUser -Properties * | Select-Object Name,Mail | Export-Csv -Path C:\Support\$grp.csv -Notypeinformation
     Write-Progress -Activity "Completeing" -Status "$PercentComplete% Complete:" -PercentComplete $PercentComplete
          }
          InfoForm "Completed Succesfully, Reports are in  C:\Support"
    }
    catch{
    
    }


})


$loginButton.Add_Click({

    Connect-MsolService
    $UserCredOP = Get-Credential
    $SessionOP = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://k/PowerShell/ -Authentication Kerberos -Credential $UserCredOP
    Import-PSSession $SessionOP -allowclobber
    lol

})


$Form.controls.AddRange(@($Groupbox1,$Groupbox2,$Groupbox3,$samName,$Label1,$emailBox,$loginButton,$password,$checkAccount,$unlock,$nasapic, $weth,$groupReport))
$Groupbox3.controls.AddRange(@($phoneNumber,$numberButton))
$Groupbox1.controls.AddRange(@($Button1,$upnCheck,$mailboxCheck))
$Groupbox2.controls.AddRange(@($roleBox,$officeBox,$dateBox,$boxxeButton,$Label2,$Label3,$Label4))


#region Logic 

#endregion

[void]$Form.ShowDialog()
