# Block-Email Cmdlet- Add Domain or Email Address to default spam list
function Block-Email{
[CmdletBinding()]
param (
    [Parameter()]
    #Uncomment to prompt for credentials
    <#[ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    [System.Management.Automation.Credential()]
    $UserCredential = [System.Management.Automation.PSCredential]::Empty #>
[String]$domainlist,[String]$addresslist
)

$ErrorActionPreference = "Stop"

#get existing credentials
$username = "" #input username here
$password = Get-Content "" | ConvertTo-SecureString #input filepath to get the content

#$UserCredential = Get-Credential
$UserCredential = New-Object System.Management.Automation.PSCredential($username,$password)

#create a session for exchange. 
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -AllowClobber

$domains = $domainlist -split " "
$addresses = $addresslist -split " "

#check if domain is input
if (!$domainlist){
    Write-Host "No domains to add.. skipping"
}
else{
    Write-Host "Adding domain names to default spam block list..."
    $domainreturn = "Adding $domains to default spam block list..."
    return $domainreturn
    Set-HostedContentFilterPolicy -identity Default -BlockedSenderDomains @{Add=$domains}
}

#check if addresslist is input 
if(!$addresslist){
    Write-Host "No Address to add...skipping"
}
else {
    Write-Host "Adding email addresses to default spam block list...."
    $emailreturn = "Adding $addresses to default spam block list..."
    return $emailreturn
    Write-Host "Adding email addresses to default spam block list...."
    Set-HostedContentFilterPolicy -Identity Default -BlockedSenders @{Add=$addresses}
}


    Remove-PSSession $Session


}