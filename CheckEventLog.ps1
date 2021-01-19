#Check-EventLog cmdlet - gets event logs for critical errors from a list of servers. 
Function Check-EventLog
{
[CmdletBinding()]

$servernames = Get-Content -path "" #pass path to server names in txt file
ForEach($server in $servernames){
Get-EventLog -ComputerName $server -LogName System -EntryType FailureAudit -Newest 10
}

}