$luaInstalled = Get-Command lua -ErrorAction SilentlyContinue

if (-not $luaInstalled) {
    Write-Host "Lua is not installed or not in your PATH. Please install Lua before running tests."
    exit 1
}

$scriptDir = Split-Path -Path $MyInvocation.MyCommand.Definition -Parent

lua Tests/TestRunner.lua $args[0] $scriptDir