﻿﻿Decision Services
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
# Example: az webapp deployment source config-zip --name contoso-decision-prod-wa --resource-group inrule-prod-rg --src InRule.Runtime.Service.zip
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

## Verify with apply rules
As a final verification that Decision Services is properly functioning, a REST call can be made to ApplyRules on the MortgageCalculator rule application.

Then call ApplyRules on your Decision Services instance:
```powershell
#Example: Invoke-RestMethod -Method 'Post' -ContentType 'application/json' -Headers @{"Accept"="application/json"; "inrule-apikey"="SampleApiKey"} -Uri https://contoso-decision-prod-wa.azurewebsites.net/HttpService.svc/ApplyRules -Body '{"RuleApp":{"FileName":"MortgageCalculator.ruleappx", "RuleAppName": "MortgageCalculator"},"EntityState":"{\"LoanInfo\": {\"Lender\": \"EZL\",\"Principal\": 300000, \"APR\": 6, \"TermInYears\": 30}}", "EntityName": "Mortgage"}'
Invoke-RestMethod -Method 'Post' -ContentType 'application/json' -Headers @{"Accept"="application/json"; "inrule-apikey"="YOUR_API_KEY"} -Uri https://WEB_APP_NAME.azurewebsites.net/HttpService.svc/ApplyRules -Body '{"RuleApp":{"FileName":"MortgageCalculator.ruleappx", "RuleAppName": "MortgageCalculator"},"EntityState":"{\"LoanInfo\": {\"Lender\": \"EZL\",\"Principal\": 300000, \"APR\": 6, \"TermInYears\": 30}}", "EntityName": "Mortgage"}'
```

If ApplyRules was successful, you should see the following result:
```
EntityState         : {"LoanInfo":{"Lender":"EZL","Principal":300000.0,"APR":6.0,"TermInYears":30,"TermInMonths":360,"MonthlyInterestRate":0.005},"PaymentS
                      ummary":{}}
Parameters          :
RequestId           : e3dac65b-4875-49b8-9bd1-e38e5669c422
RuleSessionState    :
RuleExecutionLog    :
ActiveNotifications : {}
ActiveValidations   : {}
SessionId           : 77915515-1cbc-42dc-8177-c181fc01c0c5
HasRuntimeErrors    : False
HasCompileErrors    : False
Overrides           :
ErrorMessage        :
ExecutionStatistics :
```
# Execution of Rules

After deployment, you have different options on how to execute rules. You can choose to execute rules against rule applications that are stored directly on Microsoft Azure App Service Web App itself, or against rule applications stored in an irCatalog instance.

<!-- Change this rule app to Mortgage Calculator -->

The examples below are using the [Chicago Food Tax Generator sample](https://github.com/InRule/Samples/tree/master/Authoring%20Samples/Chicago%20Food%20Tax%20Generator) and they each have different assumptions in order for you to use each.

## File-based Rule Application

This example assumes the following:
* You have the `Chicago Food Tax Generator.ruleapp` from the sample saved in your current directory,
* Your Microsoft Azure Azure Resource Group is named `inrule-prod-rg`, and
* Your Microsoft Azure Azure Web App is named `contoso-decision-prod-wa`.

You may adjust the examples below to fit your actual use case.

### Upload a rule application

First, retrieve the FTP deployment profile (url and credentials) with the [az webapp deployment list-publishing-profiles](https://docs.microsoft.com/en-us/cli/azure/webapp/deployment#az-webapp-deployment-list-publishing-profiles) command and put the values into a variable:
```powershell
az webapp deployment list-publishing-profiles --name contoso-decision-prod-wa --resource-group inrule-prod-rg --query "[?contains(publishMethod, 'FTP')].{publishUrl:publishUrl,userName:userName,userPWD:userPWD}[0]" | ConvertFrom-Json -OutVariable creds | Out-Null
```

Then, upload the rule application using those retrieved values:
```powershell
$client = New-Object System.Net.WebClient;$client.Credentials = New-Object System.Net.NetworkCredential($creds.userName,$creds.userPWD);$uri = New-Object System.Uri($creds.publishUrl + "/RuleApps/Chicago%20Food%20Tax%20Generator.ruleapp");$client.UploadFile($uri, "$pwd\Chicago Food Tax Generator.ruleapp");
```

### Apply rules
Then call ApplyRules on your Decision Services instance:
```powershell
Invoke-RestMethod -Method 'Post' -ContentType 'application/json' -Headers @{"Accept"="application/json"} -Uri https://contoso-decision-prod-wa.azurewebsites.net/HttpService.svc/ApplyRules -Body '{"RuleApp":{"FileName":"Chicago Food Tax Generator.ruleapp"},"EntityState":"{\"IsPlaceforEating\":true,\"ZIPCode\":\"60661\",\"OrderItems\":[{\"ItemType\":\"PreparedHot\",\"ItemCost\":7.0},{\"ItemType\":\"SyrupSoftDrink\",\"ItemCost\":1.5}]}","EntityName":"Order"}'
```

## irCatalog-based Rule Application

This example assumes the following:
* You have the `Chicago Food Tax Generator.ruleapp` from the sample saved to your irCatalog instance,
* Your Azure Resource Group is named `inrule-prod-rg`,
* Your irServer Azure Web App is named `contoso-decision-prod-wa`,
* Your irCatalog url is `https://contoso-catalog-prod-wa.azurewebsites.net/Service.svc`, and
* Your irCatalog username is `exampleUsername` and your password is `examplePassword`

### Provide irCatalog on each request

This allows providing the irCatalog instance in the request and Decision Services will retrieve the specified rule application from that irCatalog instance.
```powershell
Invoke-RestMethod -Method 'Post' -ContentType 'application/json' -Headers @{"Accept"="application/json"} -Uri https://contoso-decision-prod-wa.azurewebsites.net/HttpService.svc/ApplyRules -Body '{"RuleApp":{"Password":"examplePassword","RepositoryRuleAppRevisionSpec":{"RuleApplicationName":"ChicagoFoodTaxGenerator"},"RepositoryServiceUri":"https://contoso-catalog-prod-wa.azurewebsites.net/Service.svc","UserName":"exampleUsername"},"EntityState":"{\"IsPlaceforEating\":true,\"ZIPCode\":\"60661\",\"OrderItems\":[{\"ItemType\":\"PreparedHot\",\"ItemCost\":7.0},{\"ItemType\":\"SyrupSoftDrink\",\"ItemCost\":1.5}]}","EntityName":"Order"}'
```

### Provide a default irCatalog
A default irCatalog instance can be configured so Decision Services will use that catalog if you do not want to pass in its url for each request.

First, configure the appropriate application setting for the Microsoft Azure Azure App Service Web App:
```powershell
az webapp config appsettings set --name contoso-decision-prod-wa --resource-group inrule-prod-rg --settings inrule:runtime:service:catalog:catalogServiceUri="https://contoso-catalog-prod-wa.azurewebsites.net/Service.svc"
```

Then call ApplyRules on your Decision Services instance:
```powershell
Invoke-RestMethod -Method 'Post' -ContentType 'application/json' -Headers @{"Accept"="application/json"} -Uri https://contoso-decision-prod-wa.azurewebsites.net/HttpService.svc/ApplyRules -Body '{"RuleApp":{"Password":"examplePassword","RepositoryRuleAppRevisionSpec":{"RuleApplicationName":"ChicagoFoodTaxGenerator"},"UserName":"exampleUsername"},"EntityState":"{\"IsPlaceforEating\":true,\"ZIPCode\":\"60661\",\"OrderItems\":[{\"ItemType\":\"PreparedHot\",\"ItemCost\":7.0},{\"ItemType\":\"SyrupSoftDrink\",\"ItemCost\":1.5}]}","EntityName":"Order"}'
```

### Calling irServer Rule Execution Service from a browser
By default, CORS is not enabled in an Microsoft Azure Azure App Service Web App. This prevents you from making calls to your Decision Services instance via JavaScript in a browser.
To enable CORS for any calling domain you can use the following command:
```powershell
az resource update --name web --resource-group inrule-prod-rg --namespace Microsoft.Web --resource-type config --parent sites/contoso-decision-prod-wa --set properties.cors.allowedOrigins="['*']" --api-version 2015-06-01
```