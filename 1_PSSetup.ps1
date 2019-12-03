# Don't forget to Connect-AzAccount
# Script requires dotnet-sdk to be installed

$PNAME = "mcdemo"
$RESOURCE_GROUP = "trg-$PNAME"
$LOCATION = "northcentralus"

Write-Host "`nCreating a new resource group: $RESOURCE_GROUP ... (1/?)`n`n"
az group create -g $RESOURCE_GROUP -l $LOCATION

$suffix = $(Get-Random -Minimum 10000 -Maximum 99999)

$staccname = "${PNAME}stacc$suffix"
Write-Host "`nCreating a new storage account: $staccname ... (2/?)`n`n"
az storage account create -n $staccname -g $RESOURCE_GROUP -l $LOCATION --sku Standard_LRS

$stsharname = "${PNAME}share$suffix"
Write-Host "`nCreating a new storage share: $stsharname ... (3/?)`n`n"
$stacckey = az storage account keys list --account-name $staccname --query "[?keyName=='key1'].{value:value}" -o tsv
az storage share create -n $stsharname --account-name $staccname --account-key $stacckey --quota 250 --verbose

$aspname = "${PNAME}asp$suffix"
Write-Host "`nCreating a new app service plan: $aspname ... (4/?)`n`n" 
az appservice plan create -n $aspname -g $RESOURCE_GROUP -l $LOCATION --sku FREE --is-linux

$webappname = "${PNAME}web$suffix"
Write-Host "`nCreating a new web app: $webappname ... (5/?)`n`n"
az webapp create -n $webappname -p $aspname -g $RESOURCE_GROUP --runtime "DOTNETCORE|2.2" --deployment-local-git
