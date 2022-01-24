##########################################################################################
# You running this script/function means you will not blame the author(s) if this breaks your stuff. 
# This script/function is provided AS IS without warranty of any kind. Author(s) disclaim all 
# implied warranties including, without limitation, any implied warranties of merchantability or of 
# fitness for a particular purpose. The entire risk arising out of the use or performance of the sample 
# scripts and documentation remains with you. In no event shall author(s) be held liable for any damages 
# whatsoever (including, without limitation, damages for loss of business profits, business interruption, 
# loss of business information, or other pecuniary loss) arising out of the use of or inability to use 
# the script or documentation. Neither this script/function, nor any part of it other than those parts 
# that are explicitly copied from others, may be republished without author(s) express written permission. 
# Author(s) retain the right to alter this disclaimer at any time.
##########################################################################################


##########################################################################################
# Name: upload_sensors.ps1
# Version: 0.1
# Date: 24.01.2022
# Created by: Grischa Ernst gernst@vmware.com
#
# Description
# - This script will upload all .ps1 files that are in the source folder ($sourcepath) as sensor
#
# How To
# - Run the script with the parameter
#
# upload_sensors.ps1 -SourcePath "C:\Temp" -APIEndpoint "as137.awmdm.com" -APIUser "APIAdmin"-APIPassword "Password" -APIKey "123412341234" -orgGUID "1234-123-12312-312"
#
##########################################################################################
#                                    Changelog 
#
# 0.1 - Inital creation
##########################################################################################

##########################################################################################
#                                    Param 
#

param(
		[string]$SourcePath,
        [string]$APIEndpoint,
        [string]$APIUser,
        [string]$APIPassword,
        [string]$APIKey,
        [string]$OGGUID

	)

##########################################################################################
#                                    Functions

function Create-UEMAPIHeader
{
    param(
        [string] $APIUser, 
        [string] $APIPassword,
        [string] $APIKey,
        [string] $ContentType  = "json",
        [string] $Accept  = "json",
        [int] $APIVersion  = 1
    )

        #generate API Credentials
        $UserNameWithPassword  =  $APIUser + ":" + $APIPassword
        $Encoding  = [System.Text.Encoding]::ASCII.GetBytes($UserNameWithPassword)
        $EncodedString  = [Convert]::ToBase64String($Encoding)
        $Auth  = "Basic " + $EncodedString

        #generate Header
        $headers  = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
        $headers.Add("aw-tenant-code", $APIKey)
        $headers.Add("Authorization", $auth)
        $headers.Add("Accept", "application/$($Accept);version=$($APIVersion)")
        $headers.Add("Content-Type", "application/$($ContentType)")
        return $headers

}


function Create-APIApplicationBody 
{
    param(
         $sensorname,
         $orgGUID,
         $scriptcontent,
         $responsetype = "INTEGER") 
    
         $APIbody = '{
            "name": "$($sensorname)",
            "description": "",
            "is_read_only": false,
            "organization_group_uuid": "$($orgGUID)",
            "platform": "WIN_RT",
            "query_type": "POWERSHELL",
            "query_response_type": "$($responsetype)",
            "trigger_type": "SCHEDULE",
            "execution_context": "SYSTEM",
            "execution_architecture": "ALWAYS32BIT",
            "script_data": "$($scriptcontent)",
            "timeout": 0,
            "event_trigger": [
                "UNKNOWN"
            ],
            "schedule_trigger": "UNKNOWN",
            "assigned_smart_groups": []
        }'
    
            $json = $ExecutionContext.InvokeCommand.ExpandString($APIbody) 
            return $json
}

##########################################################################################
#                                    Start

#generate UEM header
$header = Create-UEMAPIHeader -APIUser $APIUser -APIPassword $APIPassword -APIKey $APIKey

#Get the sensor files
$AllFiles = Get-ChildItem $SourcePath | Where-Object {$_.Name -like "*.ps1"}

foreach($file in $AllFiles)
{
    #Get the script Data and encrypt the data
    $Data = Get-Content $file.FullName -Encoding UTF8 -Raw
    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($Data)
    $Script = [Convert]::ToBase64String($Bytes)
    
    #create JSON body
    if($file.BaseName -like "*date*")
    {
        $body = Create-APIApplicationBody -sensorname $($file.BaseName.ToLower()) -orgGUID $OGGUID -scriptcontent $Script -responsetype "DATETIME"
    }
    if($file.BaseName -like "*pending*")
    {
        $body = Create-APIApplicationBody -sensorname $($file.BaseName.ToLower()) -orgGUID $OGGUID -scriptcontent $Script -responsetype "BOOLEAN"
    }
    else 
    {
        $body = Create-APIApplicationBody -sensorname $($file.BaseName.ToLower()) -orgGUID $OGGUID -scriptcontent $Script
    }
    

    #upload sensor data
    $url  = "https://$($APIEndpoint)/API/mdm/devicesensors"
    Invoke-RestMethod $url -Method 'POST' -Headers $header -Body $body

    Write-Output "$($file.basename) uploaded"
}
