# Kudu Sync deployment script for PowerShell
$ErrorActionPreference = "Stop"

# Get script directory
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $SCRIPT_DIR

Write-Host "Current directory: $SCRIPT_DIR"

# Install dependencies
Write-Host "Installing dependencies..." -ForegroundColor Green
Set-Location "backend"
npm install --production

# Ensure web.config exists
Write-Host "Ensuring web.config is in place..." -ForegroundColor Green
if (Test-Path "web.config") {
    Copy-Item "web.config" -Destination $env:DEPLOYMENT_TARGET -Force
} else {
    Write-Warning "web.config not found in backend directory"
}

Write-Host "Deployment completed successfully!" -ForegroundColor Green 