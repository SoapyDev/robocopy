if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

if(Test-Path -Path $home\Documents\Robocopy){
Get-ChildItem $home\Documents\Robocopy -Include *.* -Recurse | ForEach  { $_.Delete()}
rm $home\Documents\Robocopy
}

if(Test-Path HKLM:\SOFTWARE\Classes\Directory\shell\RoboCopy){
Remove-Item -Path HKLM:\SOFTWARE\Classes\Directory\shell\RoboCopy -Force -Recurse
}

if(Test-Path HKLM:\SOFTWARE\Classes\Directory\shell\RoboCut){
Remove-Item -Path HKLM:\SOFTWARE\Classes\Directory\shell\RoboCut -Force -Recurse
}

if(Test-Path HKLM:\SOFTWARE\Classes\Directory\shell\RoboPaste){
Remove-Item -Path HKLM:\SOFTWARE\Classes\Directory\shell\RoboPaste -Force -Recurse
}
