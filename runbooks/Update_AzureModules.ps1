Param
(
  [Parameter(Mandatory)]
  [String]$ResourceGroup,
  [Parameter(Mandatory)]
  [String]$AutomationAccount
)

try
{
  $ResourceAppIdURI = 'https://management.core.windows.net/'
  $ModulePath = $env:SystemDrive + '\Modules'
  $LoginURI = 'https://login.windows.net/'
  $PathToAutomationModule = Get-ChildItem -Path (Join-Path -Path $ModulePath -ChildPath 'AzureRM.Automation') -Recurse
  Add-Type -Path (Join-Path -Path $PathToAutomationModule -ChildPath 'Microsoft.IdentityModel.Clients.ActiveDirectory.dll')
  $RunAsConnection = Get-AutomationConnection -Name 'AzureRunAsConnection'
  $Certifcate = Get-AutomationCertificate -Name 'AzureRunAsCertificate'
  $SubscriptionId = $RunAsConnection.SubscriptionId
  $Authority = $LoginURI + $RunAsConnection.TenantId
  $AuthContext = New-Object -TypeName 'Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext' -ArgumentList $Authority
  $ClientCertificate = New-Object -TypeName 'Microsoft.IdentityModel.Clients.ActiveDirectory.ClientAssertionCertificate' -ArgumentList $RunAsConnection.ApplicationId, $Certifcate
  $AuthResult = $AuthContext.AcquireToken($ResourceAppIdURI, $ClientCertificate)
  $AuthToken = $AuthResult.CreateAuthorizationHeader()
  $RequestHeader = @{
    'Content-Type' = 'application/json'
    'Authorization' = ('{0}' -f $AuthToken)
  }
  $JobId = [GUID]::NewGuid().ToString()
  $URI = ('https://management.azure.com/subscriptions/{0}/' -f $SubscriptionId) + ('resourceGroups/{0}/providers/Microsoft.Automation/' -f ($ResourceGroup)) + ('automationAccounts/{0}/jobs/{1}?api-version=2015-10-31' -f $AutomationAccount, ($JobId))
  $Body = (@'
            {{
               "properties":{{
               "runbook":{{
                   "name":"Update-AutomationAzureModulesForAccount"
               }},
               "parameters":{{
                    "ResourceGroupName":"{0}",
                    "AutomationAccountName":"{1}"
               }}
              }}
           }}
'@ -f $ResourceGroup, $AutomationAccount)
  Invoke-RestMethod -Uri $URI -Method Put -Body $Body -Headers $RequestHeader        
}
catch 
{
  throw $_.Exception
}