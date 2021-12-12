#requires -Version 4.0 -Modules PSDesiredStateConfiguration

Configuration InstallTelnetClient
{
  node localhost
  {
    WindowsFeature TelnetClient
    {
      Name = 'TelnetClient'
      Ensure = 'Present'
      IncludeAllSubFeature = 'True'        
    }
  }
}

InstallTelnetClient

Start-DscConfiguration -Path .\InstallTelnetClient -Wait -Force -Verbose