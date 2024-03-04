Import-Module Active-Directory
Set-Location ''
$hash = [ordered]@{'10'='Enter October here';'11'='Enter November here';'12'='Enter December here'}
$month = Get-Date -UFormat "%m"
$month = [string]$month


function Get-User{
    $script:user = Read-Host enter users username
    if(Get-ADUser -Filter 'sAMAccountName' -eq $user ){
        echo 'user found'
    }
    else{
        $try = Read-Host user not found - type y to try again
        if($try -eq 'y'){
            Get-User
        }
    }
}

function reset-Pass{
    Set-ADAccountPassword -Identity $user -NewPassword -Reset
    Set-ADUser -Identity $user -ChangePasswordAtLogon $true
}

Get-User
reset-Pass
