# Azure configuration
$RESOURCE_GROUP = "webapp-hk-dev-test1-rg"
$LOCATION = "southeastasia"
$APP_SERVICE_PLAN = "webapp-hk-dev-test1-plan"
$WEB_APP_NAME = "webapp-hk-dev-test1"
$GITHUB_REPO = "https://github.com/michael-nemtsev/nodejs_test1"
$GITHUB_BRANCH = "main"

# Check if Azure CLI is installed
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Error "Azure CLI is not installed. Please install it from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
}

# Check if logged in to Azure
try {
    $account = az account show | ConvertFrom-Json
    Write-Host "Using Azure account: $($account.name)"
} catch {
    Write-Error "Not logged in to Azure. Please run 'az login' first."
    exit 1
}

# Check for GitHub token
if (-not $env:GITHUB_TOKEN) {
    Write-Error "GitHub token not found. Please set the GITHUB_TOKEN environment variable."
    Write-Host "You can set it using: `$env:GITHUB_TOKEN = 'your_token_here'"
    exit 1
}

# Create Resource Group
Write-Host "Creating Resource Group..." -ForegroundColor Green
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create App Service Plan (Windows)
Write-Host "Creating App Service Plan..." -ForegroundColor Green
az appservice plan create `
    --name $APP_SERVICE_PLAN `
    --resource-group $RESOURCE_GROUP `
    --location $LOCATION `
    --sku B1 `
    --is-linux $false

# Create Web App
Write-Host "Creating Web App..." -ForegroundColor Green
az webapp create `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --plan $APP_SERVICE_PLAN `
    --runtime "NODE:18-lts"

# Configure Web App Settings
Write-Host "Configuring Web App Settings..." -ForegroundColor Green
az webapp config set `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --startup-file "node backend/server.js" `
    --node-version "18-lts"

# Configure application settings
Write-Host "Configuring Application Settings..." -ForegroundColor Green
az webapp config appsettings set `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --settings `
        NODE_ENV="production" `
        WEBSITE_NODE_DEFAULT_VERSION="~18" `
        SCM_DO_BUILD_DURING_DEPLOYMENT="true"

# Configure GitHub deployment
Write-Host "Configuring GitHub Deployment..." -ForegroundColor Green
az webapp deployment source config `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --repo-url $GITHUB_REPO `
    --branch $GITHUB_BRANCH `
    --git-token $env:GITHUB_TOKEN `
    --manual-integration

# Configure the build provider
Write-Host "Configuring Build Provider..." -ForegroundColor Green
az webapp config set `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --windows-fx-version "NODE|18-lts"

# Show the web app URL
Write-Host "`nDeployment completed. Web App URL:" -ForegroundColor Green
$webappUrl = az webapp show `
    --name $WEB_APP_NAME `
    --resource-group $RESOURCE_GROUP `
    --query "defaultHostName" `
    --output tsv

Write-Host "https://$webappUrl" -ForegroundColor Cyan

# Open the web app in default browser
Write-Host "`nOpening web app in browser..." -ForegroundColor Green
Start-Process "https://$webappUrl" 