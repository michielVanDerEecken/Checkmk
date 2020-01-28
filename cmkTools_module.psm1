<#
    Created by Michiel Van Der Eecken 
    Januari 2020
#>

<# Declaration of variables, please provide
    -Automation Username, Automation Secret, The CMKMaster server (ip or hostname) and the CMK Site. 
#>

[String]$AutomationUser="automation"
[String]$AutomationSecret="<automationSecret>"
[String]$cmkMaster="<host or ip address>"
[String]$cmkSite="<sitename>"
[String]$resultMessage=""
[Int]$resultCode=""

function Add-CmkHost
{
    Param([Parameter(Position=0,mandatory=$true)][string]$cmkHostName,[string]$folderName,[string]$IPAddress)

    if($IPAddress.length -gt 0)
    {
       $requestBody = 'request={"hostname":"' + $cmkHostName + '","folder":"' + $folderName + '","create_folders":"1","attributes":{"ipaddress":"'+ $IPAddress +'"}}'
    }

    else
    {
       $requestBody = 'request={"hostname":"' + $cmkHostName + '","folder":"' + $folderName + '","create_folders":"1"}'
    }
     $requestResult = Invoke-WebRequest -Method Post "http://$cmkMaster/$cmkSite/check_mk/webapi.py?action=add_host&_username=$AutomationUser&_secret=$AutomationSecret" -Body $requestBody | ConvertFrom-Json
     $resultMessage=$requestResult.result
     $resultCode=$requestResult.result_code

     if($resultCode -eq 0)
     {
        $outputMessage= "Succes! Host $cmkHostName was added."
     }
     else
     {
        $outputMessage= $resultMessage
     } 
     Write-Host $outputMessage   
}
function Delete-CmkHost
{
    Param([Parameter(Position=0,mandatory=$true)][string]$cmkHostName)

     $requestBody = 'request={"hostname":"' + $cmkHostName + '"}'   
     $requestResult = Invoke-WebRequest -Method Post "http://$cmkMaster/$cmkSite/check_mk/webapi.py?action=delete_host&_username=$AutomationUser&_secret=$AutomationSecret" -Body $requestBody | ConvertFrom-Json
     $resultMessage=$requestResult.result
     $resultCode=$requestResult.result_code
     if($resultCode -eq 0)
     {
        $outputMessage= "Succes! Host $cmkHostName was removed."
     }
     else
     {
        $outputMessage= $resultMessage
     }
     Write-Host $outputMessage    
}
function get-CmkHost
{
    Param([Parameter(Position=0,mandatory=$true)][string]$cmkHostName)

     $requestBody = 'request={"hostname":"' + $cmkHostName + '"}'
     $requestResult = Invoke-WebRequest -Method Post "http://$cmkMaster/$cmkSite/check_mk/webapi.py?action=get_host&_username=$AutomationUser&_secret=$AutomationSecret" -Body $requestBody 
 

     Write-Host $requestResult   
}
function get-AllCmkHost
{
     $requestResult = Invoke-WebRequest -Method Post "http://$cmkMaster/$cmkSite/check_mk/webapi.py?action=get_all_hosts&_username=$AutomationUser&_secret=$AutomationSecret"  | ConvertFrom-Json
     $outputMessage= $resultMessage

     Write-Host $outputMessage   
}
function get-CmkHostTags
{
     $requestResult = Invoke-WebRequest -Method Post "http://$cmkMaster/$cmkSite/check_mk/webapi.py?action=get_hosttags&_username=$AutomationUser&_secret=$AutomationSecret" 
     $requestResult.content
}


Export-ModuleMember -function Add-CmkHost
Export-ModuleMember -function Delete-CmkHost
Export-ModuleMember -Function get-CmkHost
Export-ModuleMember -Function get-AllCmkHost
Export-ModuleMember -Function get-CmkHostTags



