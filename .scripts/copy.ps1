$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent
$parentPath = Split-Path -parent $scriptDir

copy-item -Path $parentPath"\*" -Destination "C:\Program Files (x86)\World of Warcraft\_retail_\Interface\AddOns\NemesisChat" -Recurse -Force -Verbose -Exclude ".*","*.png","*.txt","*.md","LICENSE", "Tests", "Development", "test.ps1";
