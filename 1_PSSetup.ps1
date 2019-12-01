# Don't forget to Connect-AzAccount
# Script requires dotnet-sdk to be installed

$PNAME = "mcdemo"
$RESOURCE_GROUP = "trg-$PNAME"
$LOCATION = "northcentralus"

Write-Host "`nCreating a new resource group: $RESOURCE_GROUP ... (1/?)`n`n"
New-AzResourceGroup -Name $RESOURCE_GROUP -Location $LOCATION -Verbose

$suffix = $(Get-Random -Minimum 10000 -Maximum 99999)

$staccname = "$PNAMEstacc$suffix"
Write-Host "`nCreating a new storage account: $staccname ... (2/?)`n`n"
New-AzStorageAccount `
   -ResourceGroupName $RESOURCE_GROUP `
   -Location $LOCATION `
   -Name $staccname `
   -SkuName Standard_LRS

$stsharname = "$PNAMEshare$suffix"
Write-Host "`nCreating a new storage share: $stsharname ... (3/?)`n`n"
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

$aspname = "$PNAMEasp$suffix"
Write-Host "`nCreating a new app service plan: $aspname ... (4/?)`n`n" 
New-AzAppServicePlan `
    -Name $aspname `
    -ResourceGroupName $RESOURCE_GROUP `
    -Location $LOCATION `
    -Tier Free

$webappname = "$PNAMEweb$suffix"
Write-Host "`nCreating a new web app: $webappname ... (5/?)`n`n"
New-AzWebApp `
    -Name $webappname `
    -ResourceGroupName $RESOURCE_GROUP `
    -Location $LOCATION `
    -AppServicePlan $aspname

