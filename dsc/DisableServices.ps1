#requires -Version 4.0 -Modules PSDesiredStateConfiguration

Configuration DisableServices 
{
  Import-DscResource -ModuleName PSDesiredStateConfiguration
  Node localhost {
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

DisableServices

Start-DscConfiguration  -Path .\DisableServices -Wait -Force -Verbose