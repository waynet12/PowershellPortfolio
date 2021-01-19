# Change-ComputerName cmdlet- changes computer name on active directory and restarts it. 
Function Change-ComputerName{
[CmdletBinding()]
param (
[String]$computername,
[String]$newcomputername
)

BEGIN{

#define credentials
$userName = '' #enter a username here
$password = Get-Content '' #enter filepath to secure string password here. 
[Byte[]] $key = (1..16)

#convert to secure string
[SecureString]$securePassword = $password | ConvertTo-SecureString -Key $key 

#create credential object
[PSCredential]$credObject = New-Object System.Management.Automation.PSCredential -ArgumentList $userName, $securePassword
}

PROCESS{
#change the computername by invoking the command on computers
Invoke-Command -ComputerName $computername -Credential $credObject -ArgumentList $newcomputername -ScriptBlock{
param($newcomputername) Rename-Computer -NewName $newcomputername -DomainCredential $credObject -Force -restart
}

}
}