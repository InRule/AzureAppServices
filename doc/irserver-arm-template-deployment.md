irServer Rule Execution Service Arm Template Deployment
====
In this section we will be deploying the irServer Rule Execution Service.  This will create the Rule Execution app services.  To make this process easier, we'll be using an Azure Resource Manager (ARM) template, which allows us to deploy and configure all the Azure resources needed.

The arm template can be downloaded [here](https://urlhere.com) and will be needed to continue with this deployment option.

# Update the template parameters

Before deploying the ARM template, we need to define certain parameters.

Locate the _InRule.Runtime.Service.parameters.json_ file in the _FolderName_ file you dowloaded above.

Open the file with your text editor of choice and edit the parametes listed below:

#### InRule.Catalog.Service.parameters.json
| Parameter | Description |
| --------- | ----------- |
| executionServiceName | Provide a name for the Azure App Service that the execution service will run on. |
| executionServicePlanSkuName | Describes runtime services plan's pricing tier and capacity. [Plan Details](https://azure.microsoft.com/en-us/pricing/details/app-service/)|
| catalogUri | Provide the uri for the catalog service. |

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
az group deployment create -g RESOURCE_GROUP_NAME --template-file .\InRule.Runtime.Service.json --parameters .\InRule.Runtime.Service.parameters.json
```

## Verify with apply rules
As a final verification that irServer Rule Execution Service is properly functioning, a REST call can be made to ApplyRules on the InvoiceSample rule application.

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

# Execution of Rules
Follow the setps for executing rules in the [Web App Deployment](irserver-rule-execution-service.md#execution-of-rules)