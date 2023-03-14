
Write-Output "Please ensure the Csv is in the format: "
Write-Output "mail"
Write-Output "foo@ofsted.gov.uk"
Write-Output "bar@ofsted.gov.uk"


<#

    RemGroup: hashtable of all restricted groups, select what group users need to be removed from - then filter through each email, get their samaccountname and remove them from the group selected.
    Check: Redundant function incase all you need is reports on groups, without having to remove anyone - it does this by using a hashtable then saving selection in a list to be looped over in the report function
    Report: Gets reports on groups by looping over the list $list, items are added from function RemGroup or function Check
    Main: Select if you want to remove users from groups or just get a report on groups.

#>


$path = Read-Host 'Enter full path of the Csv e.g, C:\Users\foobar\Desktop\email.csv' #path of csv
$csv = Import-Csv $path

$userPrin = 'UserPrincipalName'

$list = New-Object Collections.Generic.List[string] #creates the lsit
#RemGroup: hashtable of all restricted groups, select what group users need to be removed from - then filter through each email, get their samaccountname and remove them from the group selected.
function RemGroup{
    $script:groups = [ordered]@{'1' ='RestrictedDataAcquisition';'2' = 'RestrictedDatadevelopment'; '3' = 'RestrictedRaise';'4' = 'RestrictedRaise_Sensitive';`
    '5'= 'RestrictedRAISESummaryReports'; '6' = 'RestrictedFurtherEducationandSkills';'7' = 'RestrictedFurtherEducationandSkillsRemit'; '8' = 'RestrictedSocialCare';`  #hashtable
    '9'='RestrictedSocialCare_Sensitive';'10'='RestrictedSchools';'11'='RestrictedRasam';'12'='RestrictedEarlyYearsTeam';'13'='RestrictedIndependentSchools';`
    '14'='RestrictedL3VAANDPIDPDATA';'15'='RestrictedOBREPORTS'}
    $groups

    
    $select = Read-Host "Enter a number for the group you want to remove users from"
    $list.Add($groups.$select)
    $selection = $groups.$select #Gets the assigned key to the input
    foreach($user in $csv){ #Loops over the csv
        $email = $user.email
        $user = Get-ADUser -Filter '$userPrin -eq $email' | Select-Object samaccountname #Gets samaccount name from email, which is provided on the ticket.
        Remove-ADGroupMember - Identity $selectection -Members $user
    }
    $try = Read-Host "Is another required?"
    if($try -eq 'y'){#Asks if another group is required to remove disabled accounts.
        RemGroup
    }

    Report
}
#Check: Redundant function incase all you need is reports on groups, without having to remove anyone - it does this by using a hashtable then saving selection in a list to be looped over in the report function
function Check{
    $groups
    $reportGroup = Read-Host "Enter the numbers of the groups you want a report with, if you have removed users from groups, them groups are saved - press enter to skip this step or stop selecting"
    if(!($reportGroup -eq '')){
        
        $list.add($groups.[string]$reportGroup)#Adds the selection from $groups hashtable to the list if you dont need to remove groups
        Check
        
    }
}

#Report: Gets reports on groups by looping over the list $list, items are added from function RemGroup or function Check
function Report{
    
    Check
 
    foreach($grp in $list){
        Get-ADGroupMember -Identity $grp -Recursive | Get-ADUser -Properties Mail | Select-Object Name,Mail | Export-Csv -Path C:\Users\sadmmurphy\Documents\$grp.csv -Notypeinformation #loops over list and gets reports 
    }

}
#Main: Select if you want to remove users from groups or just get a report on groups.
function Main{

    $des = [ordered]@{'1'='Report of groups?';'2'='Remove disabled accounts from groups?'}
    $des
    $repOrNot = Read-Host "Enter a number"
    if($repOrNot -eq '1'){
        Report
    }
    else{
        RemGroup
    }
}

Main