#!/bin/bash

# ----------------------
# KUDU Deployment Script
# ----------------------

# Ensure we're in the right directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Install dependencies
echo "Installing dependencies..."
cd backend
npm install --production

# Copy web.config
echo "Ensuring web.config is in place..."
cp web.config "$DEPLOYMENT_TARGET/web.config"

# Start the application
echo "Starting the application..."
cd "$DEPLOYMENT_TARGET"
echo "Deployment completed successfully!" 