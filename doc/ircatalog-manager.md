﻿irCatalog® Manager
===
The Catalog Manager is a stand-alone web application that provides an administrative interface to an irCatalog® repository.  It is used to manage and migrate Rule Applications across an organization's various staging environments including production. It also provides an interface for managing users, roles, and permissions.

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

# Deployment

## Deploy irCatalog
In order to use irCatalog Manager, make sure that you have successfully deployed [irCatalog](./ircatalog.md).

## Sign in to Microsoft® Azure®
First, [open a PowerShell prompt](https://docs.microsoft.com/en-us/powershell/scripting/setup/starting-windows-powershell) and use the Azure CLI to [sign in](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) to your Azure subscription:
```powershell
az login
```

## Set active subscription
If your Microsoft® Azure® account has access to multiple subscriptions, you will need to [set your active subscription](https://docs.microsoft.com/en-us/cli/azure/account#az-account-set) to where you create your Microsoft® Azure® resources:
```powershell
# Example: az account set --subscription "Contoso Subscription 1"
az account set --subscription SUBSCRIPTION_NAME
```

## Create resource group
Create the resource group (one resource group per environment is typical) that will contain the InRule-related Microsoft® Azure® resources with the [az group create](https://docs.microsoft.com/en-us/cli/azure/group#az-group-create) command:
```powershell
# Example: az group create --name inrule-prod-rg --location eastus
az group create --name RESOURCE_GROUP_NAME --location LOCATION
```

## Create App Service plan
Create the [App Service plan](https://docs.microsoft.com/en-us/azure/app-service/azure-web-sites-web-hosting-plans-in-depth-overview) that will host the InRule-related web apps with the [az appservice plan create](https://docs.microsoft.com/en-us/cli/azure/appservice/plan#az-appservice-plan-create) command:
```powershell
# Example: az appservice plan create --name inrule-prod-sp --resource-group inrule-prod-rg --location eastus
az appservice plan create --name APP_SERVICE_PLAN_NAME --resource-group RESOURCE_GROUP_NAME --location LOCATION
```

## Create Web App
Create the [Microsoft® Azure® App Service Web App](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview) for irCatalog Manager with the [az webapp create](https://docs.microsoft.com/en-us/cli/azure/webapp#az-webapp-create) command:
```powershell
# Example: az webapp create --name contoso-catalogmgr-prod-wa --plan inrule-prod-sp --resource-group inrule-prod-rg
az webapp create --name WEB_APP_NAME --plan APP_SERVICE_PLAN_NAME --resource-group RESOURCE_GROUP_NAME
```

## Deploy package
First, [download](https://github.com/InRule/AzureAppServices/releases/latest) the latest irCatalog Manager package (`InRule.Catalog.Manager.Web.zip`) from GitHub. Then [deploy the zip file](https://docs.microsoft.com/en-us/azure/app-service/app-service-deploy-zip) package to the Web App with the [az webapp deployment source](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment/source#az-webapp-deployment-source-config-zip) command:
```powershell
# Example: az webapp deployment source config-zip --name contoso-catalogmgr-prod-wa --resource-group inrule-prod-rg --src InRule.Catalog.Manager.Web.zip
az webapp deployment source config-zip --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --src FILE_PATH
```

## Update application settings
Update the CatalogServiceUri with the [az webapp config appsettings](https://docs.microsoft.com/en-us/cli/azure/webapp/config/appsettings?view=azure-cli-latest) command:
```powershell
# Example: az webapp config appsettings set --name contoso-catalogmgr-prod-wa --resource-group inrule-prod-rg --setting InRule.Catalog.Uri=https://contoso-catalog-prod-wa.azurewebsites.net/service.svc
az webapp config appsettings set --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --setting InRule.Catalog.Uri=CATALOG_URI/service.svc
```

## Verify successful deployment
Verify your deployment is successfully configured by visiting irCatalog Manager in your browser with the [az webapp browse](https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-browse) command and logging in:
```powershell
# Example: az webapp browse --name contoso-catalogmgr-prod-wa --resource-group inrule-prod-rg
az webapp browse --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME
```