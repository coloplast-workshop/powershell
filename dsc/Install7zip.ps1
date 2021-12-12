#requires -Version 4.0 -Modules PSDesiredStateConfiguration, cChoco
Configuration Install7zip
{
  Import-DscResource -ModuleName cChoco
  node 'localhost'
  {
    cChocoInstaller InstallChoco
    {
      InstallDir = "$env:ProgramData\chocolatey"
    }
    cChocoPackageInstaller 7zip
    {
      Name = '7zip'
      DependsOn = '[cChocoInstaller]InstallChoco'
    }
  }
}
Install7zip -OutputPath "$env:SystemDrive\DSC"
Start-DscConfiguration -Path "$env:SystemDrive\DSC" -Wait -Force