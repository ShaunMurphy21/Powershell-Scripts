function SearchMethod{
    $hashMeth = [ordered]@{'1'='sAMAccountName';'2'='mail'}
    $hashMeth
    $user = Read-Host "Enter a selection(1,2)"
    $b = $hashMeth.$user
    $a = Read-Host "Enter users $b"
    try
    {
    $user1 = Get-ADuser -Filter '$b -eq $a'
    $user1
    }
    catch{
        $try = Read-Host "No user found, press 'y' to try again!"
        if($try -eq 'y'){
            SearchMethod
        }
        else
        {
            exit
        }
        
    }
}

function clearMsSip{
    $try = Read-Host "Would you like to clear msRTCSIP-Line type y to continue"
    if($try -eq 'y')
    {
    try{
        $user | Set-ADUser -Clear msRTCSIP-Line
    }
    catch{
        $new = Write-Output "Unknown error, try again - press 'y' to try again."
        if($new -eq 'y'){
        clearMsSip}
        else{
            Write-Output "Exiting!"
            Exit
            }
        }
    }

}
SearchMethod
clearMsSip