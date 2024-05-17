#!/bin/bash

# To run this script, save it as create_azure_resources.sh and execute it in your terminal with the command:
# in a bash script run
#      bash create_azure_resources.sh
# Make sure you have the Azure CLI installed and are logged into your Azure account using az login before running the script.

# Variables
resourceGroupName="TaskClerkResourceGroup"
location="northeurope"
cosmosDbAccountName="taskclerkcosmosdb"
cosmosDbDatabaseName="TaskClerkDB"
storageAccountName="taskclerkstorage$(openssl rand -hex 5)"
containerName="taskclerkcontainer"
appServicePlanName="TaskClerkAppServicePlan"
webAppName="TaskClerkWebApp"
functionAppName="TaskClerkFunctionApp"

# Create Resource Group
az group create --name $resourceGroupName --location $location

# Create Cosmos DB Account
az cosmosdb create --name $cosmosDbAccountName --resource-group $resourceGroupName --locations regionName=$location failoverPriority=0 isZoneRedundant=False

# Create Cosmos DB Database
az cosmosdb sql database create --account-name $cosmosDbAccountName --name $cosmosDbDatabaseName --resource-group $resourceGroupName

# Create Storage Account
az storage account create --name $storageAccountName --resource-group $resourceGroupName --location $location --sku Standard_LRS

# Create Storage Container
az storage container create --name $containerName --account-name $storageAccountName

# Create App Service Plan
az appservice plan create --name $appServicePlanName --resource-group $resourceGroupName --location $location --sku P1V2 --is-linux

# Create Web App
az webapp create --name $webAppName --resource-group $resourceGroupName --plan $appServicePlanName --runtime "DOTNETCORE|5.0"

# Create Function App
az functionapp create --name $functionAppName --storage-account $storageAccountName --resource-group $resourceGroupName --plan $appServicePlanName --runtime dotnet --functions-version 3
