#requires -Version 4.0 -Modules PSDesiredStateConfiguration
Configuration NewAppsShare
{
  Import-DscResource -ModuleName xSMBShare
  node 'localhost'
  {
    xSmbShare AppSource
    {
      Name = 'Apps'
      Path = "$env:SystemDrive\Software\Apps"
      Ensure = 'Present'
      ReadAccess = 'Everyone'
    }
  }
}
NewAppsShare -OutputPath "$env:SystemDrive\DSC"
Start-DscConfiguration -Path "$env:SystemDrive\DSC" -Wait -Force