
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
        $script:user = Get-ADUser -Filter "GivenName -eq '$userNew[0]' -and sn -eq '$userNew[1]'" | Select-Object sAMAccountName
    }
}

function GiveGroup{
    $GroupNames = [ordered]@{'1' ='RestrictedDataAcquisition';'2' = 'RestrictedDatadevelopment'; '3' = 'RestrictedRaise';'4' = 'RestrictedRaise_Sensitive';`
    '5'= 'RestrictedRAISESummaryReports'; '6' = 'RestrictedFurtherEducationandSkills';'7' = 'RestrictedFurtherEducationandSkillsRemit'; '8' = 'RestrictedSocialCare';`
    '9'='RestrictedSocialCare_Sensitive';'10'='RestrictedSchools';'11'='RestrictedRasam';'12'='RestrictedEarlyYearsTeam';'13'='RestrictedIndependentSchools';`
    '14'='RestrictedL3VAANDPIDPDATA';'15'='RestrictedOBREPORTS'}
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