irCatalog Service
====
irCatalog® is a business rule management tool that provides centralized management of rules to ensure the integrity of business rules, keep everyone working on the latest version of rules, and promote sharing of common rules across customers, processes or applications.

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

# Deployment

## Getting started

Before creating and deploying the irCatalog package, the follow the steps below to log into Azure and set up the initial resources:

* [Sign in to Azure](deployment-getting-started.md#sign-in-to-azure)
* [Set active subscription](deployment-getting-started.md#set-active-subscription)
* [Create resource group](deployment-getting-started.md#create-resource-group)
* [Create App Service plan](deployment-getting-started.md#create-app-service-plan)

## Create Web App
Create the [Azure App Service Web App](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview) for the Catalog Service with the [az webapp create](https://docs.microsoft.com/en-us/cli/azure/webapp#az-webapp-create) command:
```powershell
# Example: az webapp create --name contoso-catalog-prod-wa --plan inrule-prod-sp --resource-group inrule-prod-rg
az webapp create --name WEB_APP_NAME --plan APP_SERVICE_PLAN_NAME --resource-group RESOURCE_GROUP_NAME
```

## Deploy package
First, [download](https://github.com/InRule/AzureAppServices/releases/latest) the latest irCatalog Service package (`InRule.Catalog.Service.zip`) from GitHub. Then [deploy the zip file](https://docs.microsoft.com/en-us/azure/app-service/app-service-deploy-zip) package to the Web App with the [az webapp deployment source](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment/source#az-webapp-deployment-source-config-zip) command:
```powershell
# Example: az webapp deployment source config-zip --name contoso-catalog-prod-wa --resource-group inrule-prod-rg --src InRule.Catalog.Service.zip
az webapp deployment source config-zip --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --src FILE_PATH
```

## Upload valid license file
In order for irCatalog Service to properly function, a valid license file must be uploaded to the web app. The simpliest way to upload the license file is via FTP.

First, retrieve the FTP deployment profile (url and credentials) with the [az webapp deployment list-publishing-profiles](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment#az-webapp-deployment-list-publishing-profiles) command and put the values into a variable:
```powershell
# Example: az webapp deployment list-publishing-profiles --name contoso-catalog-prod-wa --resource-group inrule-prod-rg --query "[?contains(publishMethod, 'FTP')].{publishUrl:publishUrl,userName:userName,userPWD:userPWD}[0]" | ConvertFrom-Json -OutVariable creds | Out-Null
az webapp deployment list-publishing-profiles --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --query "[?contains(publishMethod, 'FTP')].{publishUrl:publishUrl,userName:userName,userPWD:userPWD}[0]" | ConvertFrom-Json -OutVariable creds | Out-Null
```

Then, upload the license file using those retrieved values:
```powershell
# Example: $client = New-Object System.Net.WebClient;$client.Credentials = New-Object System.Net.NetworkCredential($creds.userName,$creds.userPWD);$uri = New-Object System.Uri($creds.publishUrl + "/InRuleLicense.xml");$client.UploadFile($uri, "$pwd\InRuleLicense.xml");
$client = New-Object System.Net.WebClient;$client.Credentials = New-Object System.Net.NetworkCredential($creds.userName,$creds.userPWD);$uri = New-Object System.Uri($creds.publishUrl + "/InRuleLicense.xml");$client.UploadFile($uri, "LICENSE_FILE_ABSOLUTE_PATH")
```

## Change the connection string
The irCatalog Service now needs to be configured to point to a valid irCatalog database that has been previously created.
```powershell
# Example: az webapp config appsettings set --name contoso-catalog-prod-wa --resource-group inrule-prod-rg --settings inrule:repository:service:connectionString="Server=tcp:ircatalog-server.database.windows.net,1433;Initial Catalog=ircatalog-database;Persist Security Info=False;User ID=admin;Password=%14TVpB*g$4b;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30";
az webapp config appsettings set --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --settings inrule:repository:service:connectionString="Server=tcp:SERVER_NAME.windows.net,1433;Initial Catalog=DATABASE_NAME;Persist Security Info=False;User ID=USER_NAME;Password=USER_PASSWORD;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30";
```

## Verify using irAuthor
Using irAuthor you should now be able to connect to your catalog using the url [https://WEB_APP_NAME.azurewebsites.net/service.svc](https://WEB_APP_NAME.azurewebsites.net/service.svc).
