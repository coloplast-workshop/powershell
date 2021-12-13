#Requires -Module AzureRM.Profile
#Requires -Module AzureRM.Compute

[OutputType([string])]
param (
  [Parameter(Mandatory)]
  [string]$ResourceGroupName
)

$AzureConnectionAssetName = 'AzureRunAsConnection'

try 
{
  $ServicePrincipalConnection = Get-AutomationConnection -Name $AzureConnectionAssetName         
  Write-Output -InputObject 'Logging in to Azure...'
  $Null = Add-AzureRmAccount `
  -ServicePrincipal `
  -TenantId $ServicePrincipalConnection.TenantId `
  -ApplicationId $ServicePrincipalConnection.ApplicationId `
  -CertificateThumbprint $ServicePrincipalConnection.CertificateThumbprint 
}
catch 
{
  if (!$ServicePrincipalConnection) 
  {
    throw ('Connection {0} not found.' -f $AzureConnectionAssetName)
  }
  else 
  {
    throw $_.Exception
  }
}

if ($ResourceGroupName) 
{
  $VMs = Get-AzureRmVM -ResourceGroupName $ResourceGroupName
}
else 
{
  $VMs = Get-AzureRmVM
}

foreach ($VM in $VMs) 
{
  $StopRtn = $VM | Stop-AzureRmVM -Force -ErrorAction Continue
  if (!$StopRtn.IsSuccessStatusCode) 
  {
    Write-Output -InputObject ($VM.Name + ' failed to stop')
    Write-Error -Message ($VM.Name + ' failed to stop. Error was:') -ErrorAction Continue
    Write-Error -Message (ConvertTo-Json -InputObject $StopRtn) -ErrorAction Continue
  }
  else 
  {
    Write-Output -InputObject ($VM.Name + ' has been stopped')
  }
}