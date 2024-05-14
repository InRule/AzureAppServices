﻿Decision Services
====
With Decision Services, you can call business rules from a variety of systems including J2EE applications, BPM processes and ESB orchestrations. Decision Services allows you to execute any rules stored in irCatalog or in the App Service Web App itself. Decision Services can be accessed through the Decision Service API via REST, or through the provided Swagger UI. 

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

# Deployment

## Sign in to Microsoft Azure
First, [open a PowerShell prompt](https://docs.microsoft.com/en-us/powershell/scripting/setup/starting-windows-powershell) and use the Microsoft Azure CLI to [sign in](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) to your Microsoft Azuresubscription:
```powershell
az login
```

## Set active subscription
If your Microsoft Azureaccount has access to multiple subscriptions, you will need to [set your active subscription](https://docs.microsoft.com/en-us/cli/azure/account#az-account-set) to where you create your Microsoft Azureresources:
```powershell
# Example: az account set --subscription "Contoso Subscription 1"
az account set --subscription SUBSCRIPTION_NAME
```

## Create resource group
Create the resource group (one resource group per environment is typical) that will contain the InRule-related Microsoft Azure resources with the [az group create](https://docs.microsoft.com/en-us/cli/azure/group#az-group-create) command:
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
Create the [Microsoft Azure App Service Web App](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview) for Decision Services with the [az webapp create](https://docs.microsoft.com/en-us/cli/azure/webapp#az-webapp-create) command:
```powershell
# Example: az webapp create --name contoso-decision-prod-wa --plan inrule-prod-sp --resource-group inrule-prod-rg
az webapp create --name WEB_APP_NAME --plan APP_SERVICE_PLAN_NAME --resource-group RESOURCE_GROUP_NAME
```

## Deploy package
First, [download](https://github.com/InRule/AzureAppServices/releases/latest) the latest Decision Services package (`InRule.Runtime.DecisionService.zip`) from GitHub. Then [deploy the zip file](https://docs.microsoft.com/en-us/azure/app-service/app-service-deploy-zip) package to the Web App with the [az webapp deployment source](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment/source#az-webapp-deployment-source-config-zip) command:
```powershell
# Example: az webapp deployment source config-zip --name contoso-decision-prod-wa --resource-group inrule-prod-rg --src InRule.Runtime.DecisionService.zip
az webapp deployment source config-zip --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --src FILE_PATH
```

## Upload valid license file
In order for Decision Services to properly function, a valid license file must be uploaded to the web app. The simplest way to upload the license file is via FTP.

First, retrieve the FTP deployment profile (url and credentials) with the [az webapp deployment list-publishing-profiles](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment#az-webapp-deployment-list-publishing-profiles) command and put the values into a variable:
```powershell
# Example: az webapp deployment list-publishing-profiles --name contoso-decision-prod-wa --resource-group inrule-prod-rg --query "[?contains(publishMethod, 'FTP')].{publishUrl:publishUrl,userName:userName,userPWD:userPWD}[0]" | ConvertFrom-Json -OutVariable creds | Out-Null
az webapp deployment list-publishing-profiles --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --query "[?contains(publishMethod, 'FTP')].{publishUrl:publishUrl,userName:userName,userPWD:userPWD}[0]" | ConvertFrom-Json -OutVariable creds | Out-Null
```

Then, upload the license file using those retrieved values:
```powershell
# Example: $client = New-Object System.Net.WebClient;$client.Credentials = New-Object System.Net.NetworkCredential($creds.userName,$creds.userPWD);$uri = New-Object System.Uri($creds.publishUrl + "/InRuleLicense.xml");$client.UploadFile($uri, "$pwd\InRuleLicense.xml");
$client = New-Object System.Net.WebClient;$client.Credentials = New-Object System.Net.NetworkCredential($creds.userName,$creds.userPWD);$uri = New-Object System.Uri($creds.publishUrl + "/InRuleLicense.xml");$client.UploadFile($uri, "LICENSE_FILE_ABSOLUTE_PATH");
```

## Verify by getting status details
As a final verification that Decision Services is properly functioning, a REST call can be made to the status details endpoint.

Get status details from your Decision Services instance:
```powershell
#Example: Invoke-RestMethod -Method 'Get' -ContentType 'application/json' -Headers @{"Accept"="application/json"; "inrule-apikey"="SampleApiKey"} -Uri https://contoso-decision-prod-wa.azurewebsites.net/api/status/details

Invoke-RestMethod -Method 'Get' -ContentType 'application/json' -Headers @{"Accept"="application/json"; "inrule-apikey"="YOUR_API_KEY"} -Uri https://WEB_APP_NAME.azurewebsites.net/api/status/details
```

If the request was successful, you should see results similiar to the following:
```
IsAvailable              : True
ProcessorCount           : 1
InRuleRuntimeVersion     : 5.8.1.614
InRuleRepositoryVersion  : 5.8.1.614
ProcessUpTimeMinutes     : 4.01
CacheUpTimeMinutes       : 0.63
MaxRuleAppCacheDepth     : 25
CurrentRuleAppCacheDepth : 0
ErrorMessages            : {}
PrecompileStatus         : NotConfigured
PrecompileSeconds        : 0
MachineName              : dw1sdwk000QCC
```
# Execution of Rules and Decisions

After deployment, you have different options on how to execute rules. For detailed instructions on executing rules and decisions,
visit the [Decision API](https://support.inrule.com/hc/en-us/articles/17532346873101-Decision-API) and/or [Rule Execution API](https://support.inrule.com/hc/en-us/articles/13377054188557-Rule-Execution-API) support articles.

### Calling Decision Services from a browser
By default, CORS is not enabled in an Microsoft Azure Azure App Service Web App. This prevents you from making calls to your Decision Services instance via JavaScript in a browser.
To enable CORS for any calling domain you can use the following command:
```powershell
az resource update --name web --resource-group inrule-prod-rg --namespace Microsoft.Web --resource-type config --parent sites/contoso-decision-prod-wa --set properties.cors.allowedOrigins="['*']" --api-version 2015-06-01
```