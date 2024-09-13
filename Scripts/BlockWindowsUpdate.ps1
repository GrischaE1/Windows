function Set-WindowsUpdateBlockStatus {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "KB ID Number to hide")][String] $KBArticleID,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Status of the update")][ValidateSet("Blocked", "UnBlocked")][String] $Status,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Windows Update ComObject from Search-AllUpdates")] $AllUpdates
    )

    if ($KBArticleID -like "KB*") {
        $KBArticleID = $KBArticleID.Remove(0, 2)
    }

    if ($Status -eq "Blocked") {
        foreach ($KB in $AllUpdates) {
            if ($KBArticleID -eq $kb.KBArticleIDs) {
                Write-Output "$($KBArticleID) blocked"
                $KB.IsHidden = $true
            }
        }
    }

    if ($Status -eq "UnBlocked") {

        foreach ($KB in $AllUpdates) {
            if ($KBArticleID -eq $kb.KBArticleIDs) {
                Write-Output "$($KBArticleID) unblocked"
                $KB.IsHidden = $False
            }
        }
    }

}

function Search-AllUpdates {
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Define Windows Update Source")][ValidateSet("Default", "MU", "WSUS")] $UpdateSource = "Default",
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Ignore Hide/UnHide Status to get a full list")][Switch] $IgnoreHideStatus = $False
    )

    #Create Update Session
    $updateSession = New-Object -ComObject 'Microsoft.Update.Session'
    $updateSession.ClientApplicationID = "ControlMyUpdate"
    $updateSearcher = $updateSession.CreateUpdateSearcher()

    Switch ($UpdateSource) {
        "MU" {
            # Create a new Service Manager Object
            $ServiceManager = New-Object -ComObject 'Microsoft.Update.ServiceManager'
            $ServiceManager.AddService2("7971f918-a847-4430-9279-4a52d1efe18d", 7, "") | Out-Null
            
            #configure the Update Searcher
            $updateSearcher.ServerSelection = "3"
            $updateSearcher.ServiceID = "7971f918-a847-4430-9279-4a52d1efe18d"
        }

        "WSUS" {
            $updateSearcher.ServerSelection = "1"
        }

        "Default" {
            $updateSearcher.ServerSelection = "0"
        }
    }

    
     
    
        $HiddenFilter = "IsHidden = 1"
        $updates = @()
        $updates += ($updateSearcher.Search($HiddenFilter))
        $updates += ($updateSearcher.Search($NULL))

        

    return $($Updates.Updates)
}


$AllUpdates = Search-AllUpdates | Sort-Object -Unique


Set-WindowsUpdateBlockStatus -KBArticleID "KB890830" -Status UnBlocked -AllUpdates $AllUpdates
