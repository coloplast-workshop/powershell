$resourceGroupName = 'azure-arc-rg'
$location = 'westeurope'
$automationAccountName = 'automation-account'

New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzAutomationAccount -Name $automationAccountName -Location $location -ResourceGroupName $resourceGroupName 
