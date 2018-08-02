## Create Web App for Catalog Manager
Create the [Azure App Service Web App](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview) for irServer Rule Execution Service with the [az webapp create](https://docs.microsoft.com/en-us/cli/azure/webapp#az-webapp-create) command:
```powershell
# Example: az webapp create --name contoso-execution-prod-wa --plan inrule-prod-sp --resource-group inrule-prod-rg
az webapp create --name WEB_APP_NAME --plan APP_SERVICE_PLAN_NAME --resource-group RESOURCE_GROUP_NAME
```

## Deploy package
First, [download](https://github.com/InRule/AzureAppServices/releases/latest) the latest irServer Rule Execution Service package (`InRule.Runtime.Service.zip`) from GitHub. Then [deploy the zip file](https://docs.microsoft.com/en-us/azure/app-service/app-service-deploy-zip) package to the Web App with the [az webapp deployment source](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment/source#az-webapp-deployment-source-config-zip) command:
```powershell
# Example: az webapp deployment source config-zip --name contoso-execution-prod-wa --resource-group inrule-prod-rg --src InRule.Catalog.Manager.Web.zip
az webapp deployment source config-zip --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --src FILE_PATH
```

## Update CatalogServiceUri AppSettings
Update the CatalogServiceUri with the [az webapp config appsettings command](https://docs.microsoft.com/en-us/cli/azure/webapp/config/appsettings?view=azure-cli-latest)

```powershell
# Example az webapp config appsettings set --name WebCatManTest --resource-group lkonopka --setting InRule.Catalog.Uri=https://catalogsvctest.azurewebsites.net

az webapp config appsettings set --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --setting InRule.Catalog.Uri=CATALOG_URI
```

## Verify Successful Deployment
Verify your deployment is successfully configured by visiting the catalog manager in your browser by using the [az webapp browse command](https://docs.microsoft.com/en-us/cli/azure/webapp?view=azure-cli-latest#az-webapp-browse) and logging in.

```powershell
#Example az webapp browse --name catalogmanager --resource-group inrule-prod-rg
az webapp browse --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME
```


