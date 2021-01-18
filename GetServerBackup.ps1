#GetServerBackup Cmdlet- Checks server backup and outputs backup status.
Function GetServerBackup {
[CmdletBinding()]
param
(
        [String]$ServerName
) 

#Create session for servers
$rsession = New-PSSession -ComputerName $ServerName

#Run backup status check command for servers
$rstatus = Invoke-Command -Session $rsession -ScriptBlock {$status} 
$runningstatus = Invoke-Command -Session $rsession -ScriptBlock {$runstatus} 
disconnect-pssession $rsession 
$hresult=$rstatus.errordescription 
$outstatus="Success" 
#condition to check when last backup happened and the 
if ($rstatus.hresult -eq "0" -and !$hresult) 
    { 
    $Backup = "{0} {1} {2}" -f $ServerName, $outstatus, $rstatus.endtime 
    } 
elseif ($hresult.Contains("warnings")) 
    { 
    $Backup = "{0} Warning {1}" -f $ServerName, $rstatus.endtime 
    } 
else 
    { 
    $Backup = "{0} Failed {1}" -f $ServerName, $rstatus.endtime 
    } 
if ($runningstatus.CurrentOperation) 
    {$Backup = $runningstatus.CurrentOperation} 
Write-output $Backup 

}

#Get-ServerBackup Cmdlet passes GetServerBackup to get the backup status output
function Get-ServerBackup {
param ([string[]]$ServerName
)
BEGIN {
$usedParameter =$false
if($PSBoundParameters.ContainsKey('ServerName')) {
$usedParameter = $true
}
}
PROCESS {
if ($usedParameter) {
foreach ($computer in $ServerName) {
GetServerBackup -ServerName $computer
}
} else {
GetServerBackup -ServerName $_
}
}
}
