#requires -Version 4.0 -Modules PSDesiredStateConfiguration
Configuration DisableWindowsServices 
{
  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Node 'localhost' 
  {
    Service bthserv
    {
      Name        = 'bthserv'
      StartupType = 'Disabled'
      State       = 'Stopped'
    }
    Service Fax
    {
      Name        = 'Fax'
      StartupType = 'Disabled'
      State       = 'Stopped'
    }
  }
}
DisableWindowsServices -OutputPath "$env:SystemDrive\DSC"
Start-DscConfiguration -Path "$env:SystemDrive\DSC" -Wait -Force