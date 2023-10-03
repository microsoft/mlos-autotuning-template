# Requires -Version 3.0
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# A script to prepare the build environment for the devcontainer.

$ErrorActionPreference = 'Stop'

# Make sure we're in the root of the repository.
Set-Location "$PSScriptRoot/../.."

# Make sure the .env file exists for the devcontainer to load.
if (!(Test-Path .env)) {
    Write-Host "Creating empty .env file for devcontainer."
    New-Item -Type File .env
}

Remove-Item -Recurse -Force .devcontainer/tmp
New-Item -Type Directory .devcontainer/tmp
