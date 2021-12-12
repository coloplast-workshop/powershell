#requires -Version 4.0 -Modules PSDesiredStateConfiguration

Configuration NewShare
{
  Import-DscResource -ModuleName xSMBShare
  node localhost
  {
    xSmbShare AppSource
    {
      Name = Apps
      Path = C:\Software\Apps
      Ensure = Present
      ReadAccess = 'Everyone'
    }
  }
}

NewShare

Start-DscConfiguration -Path .\NewShare -Wait -Force -Verbose