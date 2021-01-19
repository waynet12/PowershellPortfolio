#unlock-user cmdlet- unlocks a user that is locked out of active directory. Pass a username to cmdlet to unlock that user. 
Function Unlock-User{
[CmdletBinding()]
param (
[String]$username
)
$session = New-PSSession -ComputerName '' #add computername here
Invoke-Command -Session $session -ArgumentList $username -ScriptBlock {
param($username)
try{

$result = Unlock-ADAccount -Identity $username
if ($result -ne $null)
{
#write-host "Success" -ForegroundColor Green 
$returnvalue = "Success"
return $returnvalue

}
else
{#write-host "Success" -ForegroundColor Green
$returnvalue = "Success"
return $returnvalue
}
}
catch 
{
$returnvalue = $Error
return $returnvalue
}




}
}