irCatalog Manager
===
The Catalog Manager is a stand-alone web application that provides an administrative interface to an irCatalog repository.  It is used to manage and migrate Rule Applications across an organization's various staging environments including production. It also provides an interface for managing users, roles, and permissions.

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

# Deployment

## Getting started

Before creating and deploying the irCatalog Manager package, follow the steps below to log into Azure and set up the initial resources:

* [Sign in to Azure](deployment-getting-started.md#sign-in-to-azure)
* [Set active subscription](deployment-getting-started.md#set-active-subscription)
* [Create resource group](deployment-getting-started.md#create-resource-group)
* [Create App Service plan](deployment-getting-started.md#create-app-service-plan)

## Create Web App
Create the [Azure App Service Web App](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview) for irCatalog Manager with the [az webapp create](https://docs.microsoft.com/en-us/cli/azure/webapp#az-webapp-create) command:
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
Verify your deployment is successfully configured by visiting irCatalog Manager in your browser by using the [az webapp browse](https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-browse) command and logging in:
```powershell
# Example: az webapp browse --name catalogmanager --resource-group inrule-prod-rg
az webapp browse --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME
```

