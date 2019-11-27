# Don't forget to Connect-AzAccount

$RESOURCE_GROUP = "trg-azminicran"
$LOCATION = "northcentralus"

Write-Host "`nCreating a new resource group: $RESOURCE_GROUP ... (1/?)"
New-AzResourceGroup -Name $RESOURCE_GROUP -Location $LOCATION -Verbose

$suffix = $(Get-Random -Minimum 10000 -Maximum 99999)

$storageacctname = "granny$suffix"
Write-Host "`nCreating a new resource group: $RESOURCE_GROUP ... (1/?)"
New-AzStorageAccount -ResourceGroupName $RESOURCE_GROUP -Name $storageacctname -Location $LOCATION -SkuName Standard_LRS

