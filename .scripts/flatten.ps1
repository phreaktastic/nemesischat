# This file is used to copy all files from the repository to a destination directory, renaming them with the current Git branch name.
# It excludes certain files and directories from the copy process.
# The script is intended to be run manually when needed, for feeding AI to train on the files.

# Default paths
$SourcePath = (Get-Item $PSScriptRoot).Parent.FullName
$DestinationPath = "C:\Users\PC\OneDrive\Desktop\Nemesis Chat\File Dumps"

# Function to get the current Git branch name
function Get-GitBranch {
    $branch = git -C $SourcePath rev-parse --abbrev-ref HEAD 2>$null
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to get Git branch. Make sure you're in a Git repository and Git is installed."
        exit 1
    }
    return $branch
}

# Get the current Git branch
$BranchName = Get-GitBranch

# Create the destination directory if it doesn't exist
if (-not (Test-Path -Path $DestinationPath)) {
    New-Item -ItemType Directory -Path $DestinationPath | Out-Null
}

# Function to get the relative path
function Get-RelativePath {
    param (
        [string]$Path,
        [string]$BasePath
    )
    return $Path.Substring($BasePath.Length).TrimStart('\')
}

# Function to create the new file name
function Get-NewFileName {
    param (
        [string]$BranchName,
        [string]$RelativePath
    )
    return "$BranchName-$($RelativePath -replace '\\', '-')"
}

# Get all files recursively, excluding specified files and directories
$files = Get-ChildItem -Path $SourcePath -Recurse -File | 
         Where-Object { 
             $_.Name -notmatch '^\.' -and 
             $_.Extension -notin @('.png', '.txt', '.md', '.json') -and
             $_.FullName -notmatch '\\Libs\\' -and
             $_.FullName -notmatch '\\.vs\\' -and
             $_.FullName -notmatch '\\.scripts\\' -and
             $_.Name -ne 'LICENSE'
         }

# Copy and rename each file
foreach ($file in $files) {
    $relativePath = Get-RelativePath -Path $file.FullName -BasePath $SourcePath
    $newFileName = Get-NewFileName -BranchName $BranchName -RelativePath $relativePath
    $destinationFile = Join-Path -Path $DestinationPath -ChildPath $newFileName
    
    Copy-Item -Path $file.FullName -Destination $destinationFile -Force
    Write-Verbose "Copied $($file.FullName) to $destinationFile"
}

Write-Host "File copy and rename process completed for branch: $BranchName"
Write-Host "Source Path: $SourcePath"
Write-Host "Destination Path: $DestinationPath"