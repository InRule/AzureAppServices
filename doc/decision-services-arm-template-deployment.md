Decision Services Arm Template Deployment
====
In this section we will be deploying Decision Services. To make this process easier, we'll be using an Azure Resource Manager (ARM) template, which allows us to deploy and configure the Decision Services resource.

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

Get the template and parameters file from the `source.zip` [here](https://github.com/InRule/AzureAppServices/releases). Both will be needed to continue with this deployment option. The steps that follow will show how to deploy using the Azure CLI, but the provided template can also be deployed through the Azure portal.

# Update the template parameters

Before deploying the ARM template, we need to define certain parameters.

Locate the _InRule.DecisionService.parameters.json_ file downloaded above. 
<!-- double check the name and ask if I should push a commit up with a template / param.json file. -->

Open the file with your text editor of choice and edit the parameters listed below:

#### InRule.Runtime.Service.parameters.json
| Parameter | Example Values | Description |
| --------- | -------------- | ----------- |
| decisionServiceName | inruleRuntimeAppService | Provide a name for the Azure App Service that the decision service will run on. |
| decisionServicePlanSkuName | B1 | Describes runtime services plan's pricing tier and capacity. [Plan Details](https://azure.microsoft.com/en-us/pricing/details/app-service/)|
| catalogUri | https://{catalogAppService}/Service.svc | Provide the uri for the catalog service. |
| inRuleVersion | 5.8.1 | Provide the inRule version you wish to deploy, default value is the latest inRule version. |
| decisionServicePlanName | inruleDecisionServicePlan | The name for the app Service Plan.  Leave blank for the value to be derived as `decisionServiceName` + `Plan`|
| apiKey | "" | Provide an api key value that will be used to authenticate to the Decision Service. |

<!-- Do I need to mention API Key here? Probably. Be sure name in param.json matches name listed here.-->

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
az deployment group create -g RESOURCE_GROUP_NAME --template-file .\InRule.Runtime.Service.json --parameters .\InRule.Runtime.Service.parameters.json
```

## Verify with apply rules
Follow the steps to verify rules in the [Decision Services Web App Deployment](decision-services.md#verify-with-apply-rules)

# Execution of Rules
Follow the steps for executing rules in the [Decision Services App Deployment](decision-services.md#execution-of-rules)