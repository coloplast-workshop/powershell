#requires -Version 4.0 -Modules PSDesiredStateConfiguration
Configuration AddTelnetClient
{
  Import-DscResource -ModuleName PSDesiredStateConfiguration
  node 'localhost'
  {
    WindowsFeature TelnetClient
    {
      Name = 'TelnetClient'
      Ensure = 'Present'
      IncludeAllSubFeature = $true
    }
  }
}
AddTelnetClient -OutputPath "$env:SystemDrive\DSC"
Start-DscConfiguration -Path "$env:SystemDrive\DSC" -Wait -Force