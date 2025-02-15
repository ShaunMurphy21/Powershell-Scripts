﻿Import-Module ActiveDirectory

<#
    GetUser: Validates whether or not a user is in active directory, if not it asks to re-enter
    GiveGroup: Hash table of the group with the number being the value and group name being the key
    methodOfSearch: how you want to search for user
#>

function GetUser{
    if(Get-ADUser -Filter $selection -eq $user ){
        Write-Output 'User Found!'
    }
    else{
        $Validate = Read-Host 'user not found - type y to try again'
        if($Validate -eq 'y'){
            methodOfSearch
            GetUser
        }
    }
}

function methodOfSearch{
    $methodMap = [ordered]@{'1' = 'mail';'2' = 'sAMAccountName';'3' = 'Full name - Seperated by a space'}
    $methodMap
    $selection = Read-Host 'Select a number'
    $script:selection = $methodMap.$selection
    $script:user = Read-Host enter users $selection
    if($selection -eq 'Full name - Seperated by a space'){
        $userNew = $user.split(" ")
        $script:user = Get-ADUser -Filter "GivenName -eq '$userNew[0]' -and sn -eq '$userNew[1]'" | Select-Object samaccountName
    }
}

function GiveGroup{
    $GroupNames = [ordered]@{}
    $GroupNames
    $GroupSelection =  Read-Host 'Enter a number'
    $GroupSelection = $GroupNames.$GroupSelection

    Add-ADGroupMember -Identity $GroupSelection -Members $user
    $AskAgain = Read-Host 'Would you like to add another?'
    if($AskAgain -eq 'y'){
        methodOfSearch
        GetUser
        GiveGroup
    }
}
methodOfSearch
GetUser
GiveGroup
