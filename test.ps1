$luaInstalled = Get-Command lua -ErrorAction SilentlyContinue

if (-not $luaInstalled) {
    Write-Host "Lua is not installed or not in your PATH. Please install Lua before running tests."
    Write-Host "To install Lua, you can:"
    Write-Host "1. Download it from https://www.lua.org/download.html"
    Write-Host "2. Use a package manager like Chocolatey: choco install lua"
    Write-Host "3. Add Lua to your PATH after installation"
    exit 1
}

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

lua Tests/TestRunner.lua $args[0] $scriptDir