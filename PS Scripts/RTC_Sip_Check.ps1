$UserEmail = Read-Host -Prompt "Please enter the email address of the user you would like to clear"
$IsError = $false

#This Try -> catch pair checks that the email address is valid

try { $UserObject =  Get-ADUser -Filter 'UserPrincipalName -eq $UserEmail' -properties *}
catch
{
	$IsError = $true
}

 if(!$IsError){

	If (!$UserObject."msRTCSIP-Line"){ #checks if the user's msRTCSIP-Line attribute is set
        
		echo "`n`nNo msRTCSIP-Line found"

	}else{
        $outstring = "`nmsRTCSIP-Line found. Do you want to clear msRTCSIP-Line for user " + $UserObject.Name + "? (Y/N)"
	    echo  $outstring
        $response = Read-Host

            if($response -eq "Y" -or $response -eq "y"){

                Set-AdUser -Identity $UserObject -clear msRTCSIP-Line #clears the msRTCSIP-Line attribute for the user
                echo "msRTCSIP-Line has been cleared"

            }else{

                echo "`nNo user data has been modified"

            }
	}
        #The below is the email to cloud direct with some formatting, can be copied and pasted into an email
        "`n`nEmail to support@mail.clouddirect.net"
        "______________________________________________________________"
        "Hi Cloud Direct,"

        "`nPlease can you disable the voice mail for the following user:"
        "Ofsted Ref: ENTER REFERENCE"
        "Full Name :" + $UserObject.Name 
        "User email Addr :" + $UserObject.UserPrincipalName
        "Leaving Date : ENTER LEAVING DATE"
        "Assigned DDI :" + $userobject.OfficePhone
        "msRTCSIP-Line : Already Cleared in AD"
        "Process (es) Required:"
        "Disable user for enterprise voice"
        "Unassign line URI"
        "Disable Voicemail policy"
        "Set-CsUser -Identity `" " + $UserObject.UserPrincipalName + " `" -EnterpriseVoiceEnabled $False -OnPremLineUri `"tel:+44<" + $userobject.OfficePhone.SubString(1) + ">`"-HostedVoiceMail $False. "
        
        "`nRegards,"
        "IS Service Desk"

        Read-Host

}else {
	
	$UserName = Read-Host -Prompt "No user with that email address found. Please close the script and then try again."

}

