if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }


if(-Not(Test-Path -Path HKCR)){
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR
}


if(-Not(Test-Path -Path HKCR\Directory\shell\RoboCopy)){
New-Item -path "HKCR:\Directory\shell" -Name RoboCopy
New-Item -path "HKCR:\Directory\shell\RoboCopy" -Name command -Value "powershell.exe -file $home\documents\Robocopy\setInitialLocation.ps1 %V"
}


if(-Not(Test-Path -Path HKCR\Directory\shell\RoboCut)){
New-Item -path "HKCR:\Directory\shell" -Name RoboCut
New-Item -path "HKCR:\Directory\shell\Robocut" -Name command -Value "powershell.exe -file $home\documents\Robocopy\setInitialLocationCut.ps1 %V"
}


if(-Not(Test-Path -Path HKCR\Directory\shell\RoboPaste)){
New-Item -path "HKCR:\Directory\shell" -Name RoboPaste
New-Item -path "HKCR:\Directory\shell\RoboPaste" -Name command -Value "powershell.exe -file $home\documents\Robocopy\getCopyToLocation.ps1 %V"
}

cd $home\documents
if(-Not(Test-Path -Path $home\desktop\Robocopy)){
mkdir Robocopy


New-Item -Path $home\documents\Robocopy -Name getCopyToLocation.ps1 -ItemType file -Value '
$logicalProcessor = (Get-CimInstance Win32_ComputerSystem).NumberOfLogicalProcessors

if(Test-Path -Path $home\documents\Robocopy\initial.txt -PathType Leaf){

$initial = Get-Content -Path $home\documents\Robocopy\initial.txt
$copyToLocation = "$args"
robocopy "$initial" "$copyToLocation" /S /E /MT:$logicalProcessor /NFL /eta /NDL /NJH /NJS
Remove-Item -Path $home\documents\Robocopy\initial.txt
}

ElseIf(Test-Path -Path $home\documents\Robocopy\cutInitial.txt -PathType Leaf ){

$initial = Get-Content -Path $home\documents\Robocopy\cutInitial.txt
$copyToLocation = "$args"
robocopy "$initial" "$copyToLocation" /move /S /E /MT:$logicalProcessor /eta /NFL /NDL /NJH /NJS
Remove-Item -Path $home\documents\Robocopy\cutInitial.txt
}
'
New-Item -Path $home\documents\Robocopy -Name setInitialLocation.ps1 -ItemType file -Value '
if(Test-path -Path $home\documents\Robocopy\cutInitial.txt){
rm $home\documents\Robocopy\cutInitial.txt
}
if(Test-path -Path $home\documents\Robocopy\initial.txt){
rm $home\documents\Robocopy\initial.txt
}

$setInitialLocation = "$args"
New-Item -Path "$home\documents\Robocopy" -Name "initial.txt" -ItemType "file" -Value "$setInitialLocation"

'
New-Item -Path $home\documents\Robocopy -Name setInitialLocationCut.ps1 -ItemType file -Value '
if(Test-path -Path $home\documents\Robocopy\initial.txt){
rm $home\documents\Robocopy\initial.txt
}
if(Test-path -Path $home\documents\Robocopy\cutInitial.txt){
rm $home\documents\Robocopy\cutInitial.txt
}

$getInitialCut = "$args"
New-Item -Path "$home\documents\Robocopy" -Name "cutInitial.txt" -ItemType "file" -Value "$getInitialCut"

'

}

