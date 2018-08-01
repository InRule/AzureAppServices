irServer Rule Execution Service
====
If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

## Sign in to Azure
First, [open a PowerShell prompt](https://docs.microsoft.com/en-us/powershell/scripting/setup/starting-windows-powershell) and use the Azure CLI to [sign in](https://docs.microsoft.com/en-us/cli/azure/authenticate-azure-cli) to your Azure subscription:
```powershell
az login
```

## Set active subscription
If your Azure account has access to multiple subscriptions, you will need to [set your active subscription](https://docs.microsoft.com/en-us/cli/azure/account#az-account-set) to where you create your Azure resources:
```powershell
# Example: az account set --subscription "Contoso Subscription 1"
az account set --subscription SUBSCRIPTION_NAME
```

## Create resource group
Create the resouce group that will contain the InRule-related Azure resources with the [az group create](https://docs.microsoft.com/en-us/cli/azure/group#az-group-create) command:
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
Create the [Azure App Service Web App](https://docs.microsoft.com/en-us/azure/app-service/app-service-web-overview) for irServer Rule Execution Service with the [az webapp create](https://docs.microsoft.com/en-us/cli/azure/webapp#az-webapp-create) command:
```powershell
# Example: az webapp create --name contoso-execution-prod-wa --plan inrule-prod-sp --resource-group inrule-prod-rg
az webapp create --name WEB_APP_NAME --plan APP_SERVICE_PLAN_NAME --resource-group RESOURCE_GROUP_NAME
```

## Deploy package
First, [download](https://github.com/InRule/AzureAppServices/releases/latest) the latest irServer Rule Execution Service package (`InRule.Runtime.Service.zip`) from GitHub. Then [deploy the zip file](https://docs.microsoft.com/en-us/azure/app-service/app-service-deploy-zip) package to the Web App with the [az webapp deployment source](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment/source#az-webapp-deployment-source-config-zip) command:
```powershell
# Example: az webapp deployment source config-zip --name contoso-execution-prod-wa --resource-group inrule-prod-rg --src InRule.Runtime.Service.zip
az webapp deployment source config-zip --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --src FILE_PATH
```

## Upload valid license file
In order for irServer Rule Execution Service to properly function, a valid license file must be uploaded to the web app. The simpliest way to upload the license file is via FTP.

First, retrieve the FTP deployment profile (url and credentials) with the [az webapp deployment list-publishing-profiles](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment#az-webapp-deployment-list-publishing-profiles) command and put the values into a variable:
```powershell
# Example: az webapp deployment list-publishing-profiles --name contoso-execution-prod-wa --resource-group inrule-prod-rg --query "[?contains(publishMethod, 'FTP')].{publishUrl:publishUrl,userName:userName,userPWD:userPWD}[0]" | ConvertFrom-Json -OutVariable creds | Out-Null
az webapp deployment list-publishing-profiles --name WEB_APP_NAME --resource-group RESOURCE_GROUP_NAME --query "[?contains(publishMethod, 'FTP')].{publishUrl:publishUrl,userName:userName,userPWD:userPWD}[0]" | ConvertFrom-Json -OutVariable creds | Out-Null
```

Then, upload the license file using those retrieved values:
```powershell
# Example: $client = New-Object System.Net.WebClient;$client.Credentials = New-Object System.Net.NetworkCredential($creds.userName,$creds.userPWD);$uri = New-Object System.Uri($creds.publishUrl + "/InRuleLicense.xml");$client.UploadFile($uri, "$pwd\InRuleLicense.xml");
$client = New-Object System.Net.WebClient;$client.Credentials = New-Object System.Net.NetworkCredential($creds.userName,$creds.userPWD);$uri = New-Object System.Uri($creds.publishUrl + "/InRuleLicense.xml");$client.UploadFile($uri, "LICENSE_FILE_ABSOLUTE_PATH");
```

## Verify by apply rules
As a final verification that irServer Rule Execution Service is properly functioning, a REST call can be made to ApplyRules on the InvoiceSample rule applcation.

First, force the use of TLS 1.2. Otherwise the subsequent `Invoke-RestMethod` call will not work.
```powershell
[Net.ServicePointManager]::SecurityProtocol=[Net.SecurityProtocolType]::Tls12
```

Then call ApplyRules on your irServer Rule Execution Service instance:
```powershell
# Example: Invoke-RestMethod -Method 'Post' -ContentType 'application/json' -Headers @{"Accept"="application/json"} -Uri https://contoso-execution-prod-wa.azurewebsites.net/HttpService.svc/ApplyRules -Body '{"RuleApp":{"FileName":"InvoiceSample.ruleappx"},"EntityState":"{\"CustID\":\"1\",\"LineItems\":[]}","EntityName":"Invoice"}'
Invoke-RestMethod -Method 'Post' -ContentType 'application/json' -Headers @{"Accept"="application/json"} -Uri https://WEB_APP_NAME.azurewebsites.net/HttpService.svc/ApplyRules -Body '{"RuleApp":{"FileName":"InvoiceSample.ruleappx"},"EntityState":"{\"CustID\":\"1\",\"LineItems\":[]}","EntityName":"Invoice"}'
```

If ApplyRules was successful, you should see the following result:
```
ActiveNotifications : {}
ActiveValidations   : {}
EntityState         : {"CustID":1,"CustName":"Alfred Futterkiste","SubTotal":0.0,"Tax":0.00,"Total":0.00}
HasRuntimeErrors    : False
Overrides           :
Parameters          :
RequestId           : 00000000-0000-0000-0000-000000000000
RuleExecutionLog    :
RuleSessionState    :
SessionId           : 1ac58648-9c3a-4d79-83c5-2c31d2eb32d7
```
