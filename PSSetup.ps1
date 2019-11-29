# Don't forget to Connect-AzAccount

$RESOURCE_GROUP = "trg-azminicran"
$LOCATION = "northcentralus"

Write-Host "`nCreating a new resource group: $RESOURCE_GROUP ... (1/?)"
New-AzResourceGroup -Name $RESOURCE_GROUP -Location $LOCATION -Verbose

$suffix = $(Get-Random -Minimum 10000 -Maximum 99999)

$staccname = "granny$suffix"
Write-Host "`nCreating a new storage account: $staccname ... (2/?)"
New-AzStorageAccount `
   -ResourceGroupName $RESOURCE_GROUP `
   -Location $LOCATION `
   -Name $staccname `
   -SkuName Standard_LRS

$stsharname = "grannyshare$suffix"
Write-Host "`nCreating a new storage share: $stsharname ... (3/?)"
$stacckey = (Get-AzStorageAccountKey `
    -ResourceGroupName $RESOURCE_GROUP `
    -Name $staccname)[0].Value
$stctx = New-AzStorageContext `
    -StorageAccountName $staccname `
    -StorageAccountKey $stacckey
New-AzStorageShare `
    -Name $stsharname `
    -Context $stctx
Set-AzStorageShareQuota `
    -ShareName $stsharname `
    -Quota 250 `
    -Context $stctx



