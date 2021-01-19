#Get-ADComputerInfo cmdlet - queries computer information for inventory. Adds output to a spreadsheet.
function Get-ADComputerInfo {
$ErrorActionPreference = 'SilentlyContinue'
#get the server names
begin{
$computerarray = [System.Collections.ArrayList]@()
$allComputers = Get-ADComputer -Filter *  | Select-Object -ExpandProperty Name


#[System.Collections.ArrayList]$onlineComputers = $servers

foreach($allComputer in $allComputers){
if (Test-Connection -BufferSize 32 -Count 1 -ComputerName $allComputer -Quiet){
    $computerarray.Add($allComputer)
    Write-Host "$allComputer is online"
}
else{
    Write-Host "$allComputer is dead"
    continue
}

}
}
PROCESS{

$errorlist = [System.Collections.ArrayList]@()
$date = get-date -format "dd-MM-yyyy"
$excelPath = "" #output to an excel path. 
if (Test-Path -Path $excelPath)
{
    
}
else{
    Export-Excel $excelPath
}
foreach($computer in $computerarray){
#create a PSCustomObject so that you can add properties so that output looks better
$output = [ordered]@{
'ComputerName'=$null
'UserLoggedIn' = $null
'IPAddress'=$null
'DHCPEnabled' = $null
'OperatingSystem'=$null
'AvailableDriveSpace (GB)'=$null
'Memory (GB)'=$null
'Processor' = $null

}
try{
$output.ComputerName = $computer

$output.'AvailableDriveSpace (GB)' = [Math]::Round(((Get-CimInstance -ComputerName $computer -ClassName Win32_LogicalDisk -Filter 'DeviceID="C:"').FreeSpace / 1GB),1)

#may need to enable these settings if you get an error:
#dism /online /enable-feature /featurename:ServerManager-PSH-Cmdlets
#dism /online /enable-feature /featurename:BestPractices-PSH-Cmdlets


$output.'OperatingSystem' = (Get-CimInstance -ComputerName $computer -ClassName Win32_OperatingSystem).Caption

$output.'Memory (GB)' = (Get-CimInstance -ComputerName $computer -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1GB

#get-user session may need install-module get-usersession
$output.UserLoggedIn = (Get-UserSession -ComputerName $computer).username 

$output.IPAddress = (Get-CimInstance -ComputerName $computer -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").IPAddress[0]

$output.DHCPEnabled = (Get-CimInstance -ComputerName $computer -ClassName Win32_NetworkAdapterConfiguration -Filter "IPEnabled = 'True'").DHCPEnabled

$output.Processor = (Get-CimInstance -ComputerName $computer -ClassName Win32_Processor).Name

$computerrows = import-excel $excelpath

$columns = @{
    ComputerName = $computerrows.ComputerName 
}
#check if computer is already in the spreadsheet. Skip if it exists. 
if ($columns.ComputerName -contains $output.ComputerName){
    Write-Host $computer 'exists'
}
else{
    Write-Host $computer 'does not exist'
    [pscustomobject]$output | Export-Excel $excelPath -Append
}

[pscustomobject]$output | Export-Excel $excelPath -Append

}
catch{
Add-Content '' -Value "$computer not added because ($Error[0])" #add path for log output.
}
}

}
END{
    $excel = New-Object -ComObject Excel.Application
    $excel.Visible = $true
    $workbook = $excel.Workbooks.Open($excelPath)
    
}
}

#>