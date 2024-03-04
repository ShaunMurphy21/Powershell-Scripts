Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Function Get-FileName($initialDirectory)
{  

 $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
 $OpenFileDialog.initialDirectory = $initialDirectory
 $OpenFileDialog.filter = “All files (*.csv*)| *csv*”
 $OpenFileDialog.ShowDialog() | Out-Null
 $OpenFileDialog.filename
}

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(402,223)
$Form.text                       = "Form"
$Form.TopMost                    = $false

$nameGroup                       = New-Object system.Windows.Forms.Label
$nameGroup.text                  = "Name Of Group:"
$nameGroup.AutoSize              = $true
$nameGroup.width                 = 25
$nameGroup.height                = 10
$nameGroup.location              = New-Object System.Drawing.Point(8,27)
$nameGroup.Font                  = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$groupList                       = New-Object system.Windows.Forms.ListBox
$groupList.text                  = "listBox"
$groupList.width                 = 237
$groupList.height                = 30
$groupList.location              = New-Object System.Drawing.Point(115,18)
$groupList.SelectionMode = 'MultiExtended'

$Groupbox1                       = New-Object system.Windows.Forms.Groupbox
$Groupbox1.height                = 85
$Groupbox1.width                 = 392
$Groupbox1.text                  = "Reports"
$Groupbox1.location              = New-Object System.Drawing.Point(4,11)

$csvCheck                        = New-Object system.Windows.Forms.CheckBox
$csvCheck.text                   = "Remove users in CSV?"
$csvCheck.AutoSize               = $false
$csvCheck.width                  = 170
$csvCheck.height                 = 20
$csvCheck.location               = New-Object System.Drawing.Point(7,55)
$csvCheck.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$confirmButton                   = New-Object system.Windows.Forms.Button
$confirmButton.text              = "Proceed"
$confirmButton.width             = 73
$confirmButton.height            = 27
$confirmButton.location          = New-Object System.Drawing.Point(279,53)
$confirmButton.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$confirmButton.Add_Click({
    if($csvCheck.Checked){
    
        foreach($user in $csv){
        $email = $user.email
        $userS = Get-ADUser -Filter '$userPrin -eq $email' | Select-Object samaccountname
        Remove-ADGroupMember - Identity $groupList.SelectedItem -Members $userS
    }
        
    
    }
    
    foreach($grp in $groupList.SelectedItem){
        Get-ADGroupMember -Identity $grp -Recursive | Get-ADUser -Properties Mail | Select-Object Name,Mail | Export-Csv -Path C:\Support\$grp.csv -Notypeinformation
    }


})

$importButton                    = New-Object system.Windows.Forms.Button
$importButton.text               = "Import CSV"
$importButton.width              = 89
$importButton.height             = 26
$importButton.location           = New-Object System.Drawing.Point(180,53)
$importButton.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$importButton.Add_Click({


    $a = Get-FileName
    $csv = Import-Csv $a
})




$Groupbox2                       = New-Object system.Windows.Forms.Groupbox
$Groupbox2.height                = 166
$Groupbox2.width                 = 392
$Groupbox2.text                  = "Check an Account"
$Groupbox2.location              = New-Object System.Drawing.Point(4,106)

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Username:"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(13,18)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$usernameText                    = New-Object system.Windows.Forms.TextBox
$usernameText.multiline          = $false
$usernameText.width              = 196
$usernameText.height             = 20
$usernameText.location           = New-Object System.Drawing.Point(87,16)
$usernameText.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$checkButton                     = New-Object system.Windows.Forms.Button
$checkButton.text                = "Check"
$checkButton.width               = 60
$checkButton.height              = 26
$checkButton.location            = New-Object System.Drawing.Point(289,15)
$checkButton.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$checkButton.Add_Click({


    $passEx = net user $usernameText.Text /domain | select-string 'Password Expires'
    $passEx = $passEx -replace "Password Expires",""
    $passExLabel.Text = $passEx
    $currentDateLabel.Text = Get-Date
    if($enableButton.Checked){
    
        Enable-ADAccount -Identity $usernameText.Text
    
    }
})

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Current Date:"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(34,94)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "Password Expires:"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(5,68)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$passExLabel                     = New-Object system.Windows.Forms.Label
$passExLabel.text                = ""
$passExLabel.AutoSize            = $true
$passExLabel.width               = 25
$passExLabel.height              = 10
$passExLabel.location            = New-Object System.Drawing.Point(120,68)
$passExLabel.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$currentDateLabel                = New-Object system.Windows.Forms.Label
$currentDateLabel.text           = ""
$currentDateLabel.AutoSize       = $true
$currentDateLabel.width          = 25
$currentDateLabel.height         = 10
$currentDateLabel.location       = New-Object System.Drawing.Point(165,93)
$currentDateLabel.Font           = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$enableButton                    = New-Object system.Windows.Forms.CheckBox
$enableButton.text               = "Enable account?"
$enableButton.AutoSize           = $false
$enableButton.width              = 121
$enableButton.height             = 16
$enableButton.Anchor             = 'top,right,bottom,left'
$enableButton.location           = New-Object System.Drawing.Point(7,45)
$enableButton.Font               = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label6                          = New-Object system.Windows.Forms.Label
$Label6.AutoSize                 = $true
$Label6.width                    = 25
$Label6.height                   = 10
$Label6.location                 = New-Object System.Drawing.Point(23,291)
$Label6.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Groupbox1.controls.AddRange(@($nameGroup,$groupList,$csvCheck,$confirmButton,$importButton))
$Form.controls.AddRange(@($Groupbox1,$Groupbox2,$Label6))
$Groupbox2.controls.AddRange(@($Label1,$usernameText,$checkButton,$Label2,$Label3,$passExLabel,$currentDateLabel,$enableButton))


#region Logic 
$groupList_=@('')
#endregion
foreach ($group in $groupList_) {
    $groupList.Items.Add($group)
}
$Form.ShowDialog()
