Decision Services Arm Template Deployment
====
In this section we will be deploying Decision Services. To make this process easier, we'll be using an Azure Resource Manager (ARM) template, which allows us to deploy and configure the Decision Services resource.

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

Get the template and parameters file from the `source.zip` [here](https://github.com/InRule/AzureAppServices/releases). Both will be needed to continue with this deployment option. The steps that follow will show how to deploy using the Azure CLI, but the provided template can also be deployed through the [Azure portal](https://portal.azure.com/#create/Microsoft.Template).

# Update the template parameters

Before deploying the ARM template, we need to define certain parameters.

Locate the _InRule.Runtime.DecisionService.parameters.json_ file downloaded above.

Open the file with your text editor of choice and edit the parameters listed below:

#### InRule.Runtime.DecisionService.parameters.json
| Parameter | Example Values | Description |
| --------- | -------------- | ----------- |
| decisionServiceName | yourcompanyname-inrule-environment-decision | Provide a name for the Azure App Service that the decision service will run on. |
| decisionServicePlanSkuName | B1 | Describes runtime services plan's pricing tier and capacity. [Plan Details](https://azure.microsoft.com/en-us/pricing/details/app-service/)|
| catalogUri | https://{catalogAppService}/Service.svc | Provide the uri for the catalog service. |
| inRuleVersion | 5.8.1 | Provide the inRule version you wish to deploy, default value is the latest inRule version. |
| decisionServicePlanName | inruleDecisionServicePlan | The name for the app Service Plan.  Leave blank for the value to be derived as `decisionServiceName` + `Plan`|
| apiKeyPrimary | "" | Provide an api key value that will be used to authenticate to Decision Services. |

__Save copy of the parameters after deployment to refer to and use for future upgrades__

# Deploy ARM Template with Azure CLI

Now that the ARM template is configured, we’ll deploy it to get the resources up and running. The following will detail how to use the Azure CLI to deploy the ARM template (Note, this section assumes Azure CLI has already been installed):

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
Create the resource group (one resource group per environment is typical) that will contain the InRule-related Azure resources with the [az group create](https://docs.microsoft.com/en-us/cli/azure/group#az-group-create) command:
```powershell
# Example: az group create --name inrule-prod-rg --location eastus
az group create --name RESOURCE_GROUP_NAME --location LOCATION
```

## Execute the following command to deploy the ARM template
Replace __RESOURCE_GROUP_NAME__ with the name of the Azure Resource Group you want to deploy to:
```powershell
az deployment group create -g RESOURCE_GROUP_NAME --template-file .\InRule.Runtime.DecisionService.json --parameters .\InRule.Runtime.DecisionService.parameters.json
```

## Upload valid license file
In order for Decision Services to properly function, a valid license file must be uploaded to the web app. For information on how to upload your license file please refer to our [license upload documentation](/doc/upload-license-file.md).

## Verify by getting status details
As a final verification that Decision Services is properly functioning, a REST call can be made to the status details endpoint.

Get status details from your Decision Services instance:
```powershell

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

# Execution of Rules
After deployment, you have different options on how to execute rules. For detailed instructions on executing rules and decisions,
visit the [Decision API](https://docs.inrule.com/docs/decision-api) and/or [Rule Execution API](https://docs.inrule.com/docs/rule-execution-api) support articles.