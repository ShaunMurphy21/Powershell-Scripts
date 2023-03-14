Connect-MsolService
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

$gammaEmail = @'

Hi Gamma,

Could you please assign {0} to user {1} ; {2}

Thanks,
Ofsted IT Team


'@

$UserCredOP = Get-Credential
$SessionOP = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri http://e2k161hq.ofsteded.ofsted.gov.uk/PowerShell/ -Authentication Kerberos -Credential $UserCredOP
Import-PSSession $SessionOP -allowclobber

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(400,180)
$Form.text                       = "Littlefish - Scripts"
$Form.TopMost                    = $false


$emailLabel                      = New-Object system.Windows.Forms.Label
$emailLabel.text                 = "Email:"
$emailLabel.AutoSize             = $true
$emailLabel.width                = 25
$emailLabel.height               = 10
$emailLabel.location             = New-Object System.Drawing.Point(11,26)
$emailLabel.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

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
$upnCheck.location               = New-Object System.Drawing.Point(77,50)
$upnCheck.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$mailboxCheck                    = New-Object system.Windows.Forms.CheckBox
$mailboxCheck.text               = "Migrate Mailbox?"
$mailboxCheck.AutoSize           = $false
$mailboxCheck.width              = 180
$mailboxCheck.height             = 20
$mailboxCheck.location           = New-Object System.Drawing.Point(77,70)
$mailboxCheck.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$assignButton                    = New-Object system.Windows.Forms.Button
$assignButton.text               = "Licenses,Number,Pass"
$assignButton.width              = 113
$assignButton.height             = 70
$assignButton.location           = New-Object System.Drawing.Point(265,20)
$assignButton.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',9)

$boxxeButton                    = New-Object system.Windows.Forms.Button
$boxxeButton.text               = "Boxxe Task"
$boxxeButton.width              = 113
$boxxeButton.height             = 40
$boxxeButton.location           = New-Object System.Drawing.Point(265,90)
$boxxeButton.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',9)


$TextBox2                        = New-Object system.Windows.Forms.TextBox
$TextBox2.multiline              = $false
$TextBox2.width                  = 175
$TextBox2.height                 = 20
$TextBox2.location               = New-Object System.Drawing.Point(78,100)
$TextBox2.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$NumLabel                      = New-Object system.Windows.Forms.Label
$NumLabel.text                 = "Number:"
$NumLabel.AutoSize             = $true
$NumLabel.width                = 25
$NumLabel.height               = 10
$NumLabel.location             = New-Object System.Drawing.Point(11,103)
$NumLabel.Font                 = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$Form.controls.AddRange(@($emailLabel,$TextBox1,$upnCheck,$mailboxCheck,$assignButton,$TextBox2,$NumLabel,$boxxeButton))


$assignButton.Add_Click({

    try{

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
        $newUPN = $name.GivenName + '.' + $name.Surname +'@Ofsted.Gov.UK'
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

        Get-ADUser -Identity $user.samaccountname | Move-ADObject -TargetPath "OU=Windows 10 Users,OU=Mobile,OU=Ofsted User Accounts,DC=Ofsteded,DC=Ofsted,DC=Gov,DC=Uk"
        Set-User -Identity $user.samaccountname -fax "LTA"
        Set-ADUser -Identity $user.samaccountname -Enable:$true
        Start-Sleep -Seconds 5
        $MB1 = Get-ADUser $user.samaccountname
        $MB3 = $MB1.UserPrincipalName
        $MB4 = $MB1.SamAccountName + '@Ofsted365.mail.onmicrosoft.com'

        Enable-RemoteMailbox -Identity $MB3 -RemoteRoutingAddress $MB4
        Start-Sleep -Seconds 1
        
        }
        catch{
            InfoForm "Error Migrating Mailbox, Use old script."
        }
    }

    try{
    $a = Get-Date -Format "MM"
    $a = [int]$a

    $a = switch($a)
    
    {

    02{"FebruaryPhoneTent@7"}
    03{"MarchCloudHappy@7"}
    04{"AprilNokiaWater@7"}
    05{"MayPencilWire@7"}
    06{"JuneBridgeAgile@7"}
    07{"JulyBrickBent@7"}
    08{"AugustPlayError@7"}
    09{"SeptemberRuffleCake@7"}
    10{"OctoberNotebookHelp@7"}
    11{"NovemberShufflePaid@7"}
    12{"DecemberPlankWedding@7"}

    }


    $user = Get-ADUser -Identity $user.samaccountname
    $gammaEmail = $gammaEmail -f $TextBox2.Text, $user.Name, $newUPN
    Set-ADUser $user -OfficePhone $TextBox2.Text
    Set-Clipboard $gammaEmail
    try{
    Set-ADAccountPassword -Identity $user.samaccountname -Reset -NewPassword (ConvertTo-SecureString -AsPlainText "$a" -Force)
        InfoForm "Number added, email in clipboard and password reset."}
    catch{InfoForm "Error assigning password"}
    }

    catch{
    
        InfoForm "Error Assigning Number - do manually."
    
    }


    InfoForm "Actions Completed."
    
})

function boxxebuild{

$hashLocation = @{'Birmingham'='
23 Stephenson Street
Birmingham
B2 4BH';
'Bristol'='
2 Rivergate
Temple Quay
Bristol
BS1 6EH';'Cambridge'='
1st floor
Eastbrook
Shaftesbury Road
Cambridge
CB2 8DR';'London'='
Clive House
70 Petty France
Westminster
London
SW1H 9EX';'Manchester'='
Piccadilly Gate​
Store Street
Manchester
M1 2WD';'Nottingham' = '
Agora
6 Cumberland Place
Nottingham
NG1 6HJ';'York'='
2nd Floor​
Foss House
Kings Pool
1-2 Peasholme Green
York
YO1 7PX'}

$hmi_scri = @('PSU x1	Headset x1	Bag x1	Port Replicator x1	Monitor x1	KB x1	Mouse x1	Printer x1	Surge protector x1	Mobile x1','Surface Pro 7/7+')
$eyri = @('PSU x1	Headset x1	Bag x1	Port Replicator x1	Monitor x1	KB x1	Mouse x1	Printer x1	Surge protector x1	Mobile x1','Surface Laptop 4')
$director = @('PSU x1 Headset x1 Mobile x1','Surface Pro 7')
$bi_it = @('PSU x1 Headset x1','Surface Pro 7/7+')
$hybrid = @('PSU x1 Headset x1','Surface Pro 5/6')
$office = @('PSU x1 Headset x1','Surface Pro 5/6')
$Contractor = @('PSU x1','Lenovo 260')


$Form0                            = New-Object system.Windows.Forms.Form
$Form0.ClientSize                 = New-Object System.Drawing.Point(400,227)
$Form0.text                       = "Form"
$Form0.TopMost                    = $false

$kitlabel                        = New-Object system.Windows.Forms.Label
$kitlabel.text                   = "Softbox Build"
$kitlabel.AutoSize               = $true
$kitlabel.width                  = 25
$kitlabel.height                 = 10
$kitlabel.location               = New-Object System.Drawing.Point(128,19)
$kitlabel.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',20)

$rolelabel                        = New-Object system.Windows.Forms.Label
$rolelabel.text                   = "Role:"
$rolelabel.AutoSize               = $true
$rolelabel.width                  = 25
$rolelabel.height                 = 10
$rolelabel.location               = New-Object System.Drawing.Point(80,100)
$rolelabel.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$samText                         = New-Object system.Windows.Forms.TextBox
$samText.multiline               = $false
$samText.width                   = 190
$samText.height                  = 20
$samText.location                = New-Object System.Drawing.Point(120,66)
$samText.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$samLabel                        = New-Object system.Windows.Forms.Label
$samLabel.text                   = "Username:"
$samLabel.AutoSize               = $true
$samLabel.width                  = 25
$samLabel.height                 = 10
$samLabel.location               = New-Object System.Drawing.Point(45,69)
$samLabel.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Office to deliver to:"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(9,128)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',9)



$ComboBox2                       = New-Object system.Windows.Forms.ComboBox
$ComboBox2.width                 = 190
$ComboBox2.height                = 20
@('Birmingham','Bristol','Cambridge','London','Manchester','Nottingham','York') | ForEach-Object {[void] $ComboBox2.Items.Add($_)}
$ComboBox2.location              = New-Object System.Drawing.Point(120,125)
$ComboBox2.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)



$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Date of delivery:"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(20,158)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',9)

$dateText                        = New-Object system.Windows.Forms.TextBox
$dateText.multiline              = $false
$dateText.width                  = 190
$dateText.height                 = 20
$dateText.location               = New-Object System.Drawing.Point(120,154)
$dateText.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$emailButton                     = New-Object system.Windows.Forms.Button
$emailButton.text                = "Generate Email"
$emailButton.width               = 192
$emailButton.height              = 30
$emailButton.location            = New-Object System.Drawing.Point(120,180)
$emailButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$ComboBox1                       = New-Object system.Windows.Forms.ComboBox
$ComboBox1.width                 = 190
$ComboBox1.height                = 20
@('HMI/SCRI','EYRI','Director Level','IT Role','Hybrid Worker','Office Based','Contractor') | ForEach-Object {[void] $ComboBox1.Items.Add($_)}
$ComboBox1.location              = New-Object System.Drawing.Point(120,98)
$ComboBox1.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)


$Form0.controls.AddRange(@($kitlabel,$samText,$samLabel,$Label1,$Label2,$dateText,$emailButton,$ComboBox1,$ComboBox2,$rolelabel))

$boxxeEmail = @'
Boxxe please can you reply back with a ticket reference once this has been logged and confirm when collected
NEW STARTER
 
The name of the user: {0}
Job Role (One of: HMI; SCRI; EYRI; Director level; BI Developer/ IT Role; Hybrid Worker; Office Based; Contractor ): {1}
Device Type: {2}
Any additional item(s) requested: {3}
Username: {4}
Password:{5}
Email: {6}
Delivery Date: {7}
Phone number (if needed for DPD updates): Managers Phone: {8}
Delivery address: {9}

Thanks,
IT Service Desk Team

'@


$emailButton.Add_Click({
 
    if($ComboBox1.SelectedItem -eq 'HMI/SCRI'){$a = $hmi_scri}
    if($ComboBox1.SelectedItem -eq 'EYRI'){$a = $eyri}
    if($ComboBox1.SelectedItem -eq 'Director Level'){$a = $director}
    if($ComboBox1.SelectedItem -eq 'IT Role'){$a = $bi_it}
    if($ComboBox1.SelectedItem -eq 'Hybrid Worker'){$a = $hybrid}
    if($ComboBox1.SelectedItem -eq 'Office Based'){$a = $office}
    if($ComboBox1.SelectedItem -eq 'Contractor'){$a = $Contractor}

    $user = Get-ADUser $samText.Text -Properties *
    $new = Get-ADUser $user.Manager -Properties * | select Name
    $manPhone = Get-ADUser $user.Manager -Properties * | select -ExpandProperty OfficePhone
    $b = Get-Date -Format "MM/yyyy"
    $boxxeEmail = $boxxeEmail -f $user.SamAccountName,$ComboBox1.SelectedItem,$a[1],$a[0],$user.SamAccountName,$b,$user.UserPrincipalName,$dateText.Text,$manPhone,$hashLocation.($ComboBox2.SelectedItem)

    Set-Clipboard $boxxeEmail


})




#region Logic 

#endregion

[void]$Form0.ShowDialog()

}

$boxxeButton.Add_Click({

boxxebuild

})

[void]$Form.ShowDialog()



