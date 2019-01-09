Import-Module PSWriteWord -Force

### Before running this script make sure to run Example-CreateWord first
$FilePath = "$Env:USERPROFILE\Desktop\PSWriteWord-Example-CreateWord1.docx"

$WordDocument = Get-WordDocument -FilePath $FilePath
$WordDocument.Paragraphs
