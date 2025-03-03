#!/bin/bash

# Azure configuration
RESOURCE_GROUP="webapp-hk-dev-test1-rg"
LOCATION="southeastasia"
APP_SERVICE_PLAN="webapp-hk-dev-test1-plan"
WEB_APP_NAME="webapp-hk-dev-test1"
GITHUB_REPO="https://github.com/michael-nemtsev/nodejs_test1"
GITHUB_BRANCH="main"

# Create Resource Group
echo "Creating Resource Group..."
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create App Service Plan (Windows)
echo "Creating App Service Plan..."
az appservice plan create \
    --name $APP_SERVICE_PLAN \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \
    --sku B1 \
    --is-linux false

# Create Web App
echo "Creating Web App..."
az webapp create \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --plan $APP_SERVICE_PLAN \
    --runtime "NODE:18-lts"

# Configure Web App Settings
echo "Configuring Web App Settings..."
az webapp config set \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --startup-file "node backend/server.js" \
    --node-version "18-lts"

# Configure application settings
echo "Configuring Application Settings..."
az webapp config appsettings set \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --settings \
        NODE_ENV="production" \
        WEBSITE_NODE_DEFAULT_VERSION="~18" \
        SCM_DO_BUILD_DURING_DEPLOYMENT="true"

# Configure GitHub deployment
echo "Configuring GitHub Deployment..."
az webapp deployment source config \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --repo-url $GITHUB_REPO \
    --branch $GITHUB_BRANCH \
    --git-token "$GITHUB_TOKEN" \
    --manual-integration

# Configure the build provider
echo "Configuring Build Provider..."
az webapp config set \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --linux-fx-version "NODE|18-lts"

# Show the web app URL
echo "Deployment completed. Web App URL:"
az webapp show \
    --name $WEB_APP_NAME \
    --resource-group $RESOURCE_GROUP \
    --query "defaultHostName" \
    --output tsv 