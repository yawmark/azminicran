# Don't forget to az login
# Script requires dotnet-sdk to be installed

$PNAME = "mcdemo"
$RESOURCE_GROUP = "trg-$PNAME"
$LOCATION = "northcentralus"

Write-Host "`nCreating a new resource group: $RESOURCE_GROUP ... (1/7)`n`n"
az group create -g $RESOURCE_GROUP -l $LOCATION

$suffix = $(Get-Random -Minimum 10000 -Maximum 99999)

$staccname = "${PNAME}stacc$suffix"
Write-Host "`nCreating a new storage account: $staccname ... (2/7)`n`n"
az storage account create -n $staccname -g $RESOURCE_GROUP -l $LOCATION --sku Standard_LRS

$stsharname = "${PNAME}share$suffix"
Write-Host "`nCreating a new storage share: $stsharname ... (3/7)`n`n"
$stacckey = az storage account keys list --account-name $staccname --query "[?keyName=='key1'].{value:value}" -o tsv
az storage share create -n $stsharname --account-name $staccname --account-key $stacckey --quota 250 --verbose

$aspname = "${PNAME}asp$suffix"
Write-Host "`nCreating a new app service plan: $aspname ... (4/7)`n`n" 
az appservice plan create -n $aspname -g $RESOURCE_GROUP -l $LOCATION --sku FREE --is-linux

$webappname = "${PNAME}web$suffix"
Write-Host "`nCreating a new web app: $webappname ... (5/7)`n`n"
az webapp create -n $webappname -p $aspname -g $RESOURCE_GROUP --runtime '"DOTNETCORE|2.2"' 

Write-Host "`nDeploying local git ... (6/7)`n`n"
$DEP_USER = "${PNAME}gituser$(Get-Random -Minimum 10000 -Maximum 99999)"
$DEP_PW = "${PNAME}$(Get-Random)"
az webapp deployment user set --user-name $DEP_USER --password $DEP_PW
az webapp deployment source config-local-git --name $webappname --resource-group $RESOURCE_GROUP
$GIT_URL = "https://${DEP_USER}:${DEP_PW}@${webappname}.scm.azurewebsites.net/${webappname}.git"
$REMOTE_NAME = "azure"
$gitcmd = If (git remote | Select-String $REMOTE_NAME) { "set-url" } Else { "add" }
git remote $gitcmd $REMOTE_NAME $GIT_URL 
git push azure master

Write-Host "`nMapping Azure file share ... (7/7)`n`n"
az webapp config storage-account add -g $RESOURCE_GROUP -n $webappname --access-key $stacckey --account-name $staccname --custom-id "web${stsharname}" --share-name $stsharname --storage-type AzureFiles --mount-path /home/site/wwwroot/wwwroot
