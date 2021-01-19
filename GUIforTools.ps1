 #GUI menu for IT tools for Windows server administration. Click on buttons to perform each function 
 
 #To use .NET functionality to create forms, use class System.Windows.Forms
[void][Reflection.Assembly]::LoadWithPartialName('Microsoft.VisualBasic')



Add-Type -assembly System.Windows.Forms



#create screen form to contain elements
$main_form = New-Object System.Windows.Forms.Form

#set the title and size of window:
$main_form.Text = 'GUI for IT Management'
$main_form.Width = 600
$main_form.Height = 400


#To make the form automatically stretch, use autosize property
$main_form.AutoSize = $true


#Create label for header
$HeaderLabel = New-Object System.Windows.Forms.Label
$HeaderLabel.Text = "Bioseal IT Powershell Management"
$HeaderLabel.Size = New-Object System.Drawing.Size(200,20)
$HeaderLabel.Location = New-Object System.Drawing.Size(180,10)
$main_form.Controls.Add($HeaderLabel)


#Check Backup button on form: 
$CheckBackupsButton = New-Object System.Windows.Forms.Button
$CheckBackupsButton.Location = New-Object System.Drawing.Size(10,40)
$CheckBackupsButton.Size = New-Object System.Drawing.Size(120,23)
$CheckBackupsButton.Text = "Check Backup"
$main_form.Controls.Add($CheckBackupsButton)

#Check Task Scheduler Result Form
$TaskSchedulerResultButton = New-Object System.Windows.Forms.Button
$TaskSchedulerResultButton.Location = New-Object System.Drawing.Size(200,40)
$TaskSchedulerResultButton.Size = New-Object System.Drawing.Size(140,23)
$TaskSchedulerResultButton.Text = "Check Task Scheduler"
$main_form.Controls.Add($TaskSchedulerResultButton)

#Check Task Scheduler Result Form
$ChangeComputerNameButton = New-Object System.Windows.Forms.Button
$ChangeComputerNameButton.Location = New-Object System.Drawing.Size(200,70)
$ChangeComputerNameButton.Size = New-Object System.Drawing.Size(140,23)
$ChangeComputerNameButton.Text = "Change Computer Name"
$main_form.Controls.Add($ChangeComputerNameButton)

#Unlock a User
$UnlockUserButton = New-Object System.Windows.Forms.Button
$UnlockUserButton.Location = New-Object System.Drawing.Size(200,100)
$UnlockUserButton.Size = New-Object System.Drawing.Size(140,23)
$UnlockUserButton.Text = "Unlock User"
$main_form.Controls.Add($UnlockUserButton)

$main_form.TopMost = $true

#Unlock a User
$CheckEventLogButton = New-Object System.Windows.Forms.Button
$CheckEventLogButton.Location = New-Object System.Drawing.Size(400,40)
$CheckEventLogButton.Size = New-Object System.Drawing.Size(140,23)
$CheckEventLogButton.Text = "Check EventLog"
$main_form.Controls.Add($CheckEventLogButton)

$main_form.TopMost = $true

#Get Computer Inventory
$GetComputerInventoryButton = New-Object System.Windows.Forms.Button
$GetComputerInventoryButton.Location = New-Object System.Drawing.Size(10,70)
$GetComputerInventoryButton.Size = New-Object System.Drawing.Size(150,23)
$GetComputerInventoryButton.Text = "Get Computer Inventory"
$main_form.Controls.Add($GetComputerInventoryButton)

#Get Computer Inventory
$BlockEmailButton = New-Object System.Windows.Forms.Button
$BlockEmailButton.Location = New-Object System.Drawing.Size(10,100)
$BlockEmailButton.Size = New-Object System.Drawing.Size(150,23)
$BlockEmailButton.Text = "Add Email to Spam Filter"
$main_form.Controls.Add($BlockEmailButton)

#Get output for backups
$Label3 = New-Object System.Windows.Forms.TextBox
$Label3.Text = ""
$Label3.Size = New-Object System.Drawing.Size(600,200)
$Label3.Location  = New-Object System.Drawing.Size(5,200)
$Label3.AutoSize = $true
$Label3.Multiline = $true
$Label3.ScrollBars = "Vertical"
$main_form.Controls.Add($Label3)


#Create label for output
$OutputLabel = New-Object System.Windows.Forms.Label
$OutputLabel.Text = "Output Data:"
$OutputLabel.Size = New-Object System.Drawing.Size(100,30)
$OutputLabel.Location = New-Object System.Drawing.Size(250,180)
$main_form.Controls.Add($OutputLabel)



#Executes when user clicks on button
Import-Module "" #pass path to getserverbackup.ps1
$CheckBackupsButton.Add_Click(
{
$Label3.Text = Get-ServerBackup -ServerName(Get-Content "\\Server01-dell\f_drive\Bioseal Intranet Zone\IT Maintenance\Powershell\ServerMaintenance\servernames.txt") | Out-String

}
)
Import-Module "" #pass path to checktaskscheduler.ps1
$TaskSchedulerResultButton.Add_Click(
{

$Label3.Text =  get-taskschedulerresult | Select-Object -Property TaskName,LastRunTime,LastTaskResult | Out-String

}
)
Import-Module "" #pass path to changecomputernames.ps1
$ChangeComputerNameButton.Add_Click(
{
$title = 'Change Computer Name'
$msg   = 'Enter the old computer name:'
$msg2   = 'Enter the new computer name:'
$oldcomputername = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
$newcomputername = [Microsoft.VisualBasic.Interaction]::InputBox($msg2, $title)
Change-ComputerName -computername $oldcomputername -newcomputername $newcomputername
}
)

import-module "" #pass path to unlockaduser.ps1
$UnlockUserButton.Add_Click{
$title = 'Unlock User'
$msg   = 'Enter the user first and last name, no spaces:'
$username = [Microsoft.VisualBasic.Interaction]::InputBox($msg, $title)
Unlock-User -username $username
$returnvalue = Unlock-User($username)
$Label3.Text = $returnvalue
}

import-module "" #pass path to checkeventlog.ps1
$CheckEventLogButton.Add_Click{
$Label3.Text = ""
$servernames = Get-Content "\\Server01-dell\f_drive\Bioseal Intranet Zone\IT Maintenance\Powershell\ServerMaintenance\ServerNames.txt"
foreach ($servername in $servernames){

$EventLog =  Get-Eventlog -ComputerName $servername -LogName System -Newest 1000 | where {$_.EntryType -eq "0"} 
$Label3.Text +=  $servername 
$Label3.Text += Get-Eventlog -ComputerName $servername -LogName System -Newest 1000 | where {$_.EntryType -eq "0"} | select-object TimeWritten,EntryType,Source,Message | Out-String
}
}

Import-Module "" #pass path to addemailtospamlist.ps1
$BlockEmailButton.Add_Click{
    #Block Email Address or domain input form
    $blockemailform = New-Object System.Windows.Forms.Form
    $blockemailform.Text = "Credentials Entry"
    $blockemailform.Size = New-Object System.Drawing.Size(400,300)
    #ok button
    $okButton = New-Object System.Windows.Forms.Button
    $okButton.Location = New-Object System.Drawing.Point(75,200)
    $okButton.Size = New-Object System.Drawing.Size(75,23)
    $okButton.Text = "Ok"
    $okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $blockemailform.AcceptButton = $okButton
    $blockemailform.Controls.Add($okButton)
    #cancel button
    $cancelButton = New-Object System.Windows.Forms.Button
    $cancelButton.Location = New-Object System.Drawing.Point(150,200)
    $cancelButton.Size = New-Object System.Drawing.Point(75,23)
    $cancelButton.Text = 'Cancel'
    $cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $blockemailform.CancelButton = $cancelButton
    $blockemailform.Controls.Add($cancelButton)
#email address label
$emailLabel = New-Object System.Windows.Forms.Label
$emailLabel.Location = New-Object System.Drawing.Point(10,20)
$emailLabel.Size = New-Object System.Drawing.Size(300,20)
$emailLabel.Text = 'Type in an Email Address to Block (leave blank if none):'
$blockemailform.Controls.Add($emailLabel)
    #email address text box
    $emailTextBox = New-Object System.Windows.Forms.TextBox
$emailTextBox.Location = New-Object System.Drawing.Point(10,40)
$emailTextBox.Size = New-Object System.Drawing.Size(300,20)
$blockemailform.Controls.Add($emailTextBox)
    #domain to block label
    $domainlabel = New-Object System.Windows.Forms.Label
    $domainlabel.Location = New-Object System.Drawing.Point(10,80)
    $domainlabel.Size = New-Object System.Drawing.Size(300,20)
    $domainlabel.Text = 'Type in a Domain to Block (leave blank if none):'
    $blockemailform.Controls.Add($domainlabel)
    #domain to block text box
    $domainTextBox = New-Object System.Windows.Forms.TextBox
$domainTextBox.Location = New-Object System.Drawing.Point(10,100)
$domainTextBox.Size = New-Object System.Drawing.Size(300,20)
$blockemailform.Controls.Add($domainTextBox)
$blockemailform.StartPosition = 'CenterScreen'
$blockemailform.TopMost = $true
    $blockemailform.Add_Shown({$emailTextBox.Select()})
    $result = $blockemailform.ShowDialog()
    if ($emailTextBox.Text -ne ""){

        $Label3.Text = Block-Email -addresslist $emailTextBox.Text 

    }
    elseif ($domainTextBox.Text -ne ""){
        $block = Block-Email -domainlist $domainTextBox.Text
        $Label3.Text +=  $block.status
        $Label3.Text +=  $block.done
    }
    else{
        
        $Label3.Text = Block-Email -domainlist $domainTextBox.Text -addresslist $emailTextBox.Text
    }
}
#pass path to get-adcomputerinfo.ps1
import-module "" 
$GetComputerInventoryButton.Add_Click{
Get-ADComputerInfo
$Label3.Text = 'Please wait for the excel document to process and open.'
}
#Now you can display the form on the screen.
$main_form.ShowDialog()