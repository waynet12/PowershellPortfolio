#Get-TaskSchedulerResult Cmdlet- gets the status for tasks
Function Get-TaskSchedulerResult{
[CmdletBinding()]
param (
[string]$TaskName
)
BEGIN{

#define credentials
$userName = '' #Put username here
$password = Get-Content '' #Put filepath for secure string password
[Byte[]] $key = (1..16)

#convert password to secure string
[SecureString]$securePassword = $password | ConvertTo-SecureString -Key $key 

#create credential object
[PSCredential]$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $userName, $securePassword
}
PROCESS{
#Checks the 
Invoke-Command -ScriptBlock {Get-ScheduledTask -TaskName (Get-Content "\\Server01-dell\F_DRIVE\Bioseal Intranet Zone\IT Maintenance\Powershell\ServerMaintenance\CheckScheduledTasks\EpicorTaskNames.txt") | Get-ScheduledTaskInfo | Select-Object -Property TaskName,LastRunTime,LastTaskResult} -ComputerName "" #input computername that contains tasks
}
}