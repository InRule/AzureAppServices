Salesforce API ARM Template Deployment
====
In this section, we will deploy the **InRule Salesforce API** to Azure using an Azure Resource Manager (ARM) template. This method allows for automated provisioning and configuration of all required Azure resources for hosting the Salesforce Rule Execution Service.

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

Get the template and parameters file from the `source.zip` [here](https://github.com/InRule/AzureAppServices/releases). Both will be needed to continue with this deployment option. The steps that follow will show how to deploy using the Azure CLI, but the provided template can also be deployed through the [Azure portal](https://portal.azure.com/#create/Microsoft.Template).

# Update the template parameters

Before deploying the ARM template, we need to define certain parameters.

Locate the _InRule.Salesforce.parameters.json_ file downloaded above.

Open the file with your text editor of choice and edit the parameters listed below:

#### InRule.Salesforce.parameters.json

| Parameter | Example Values | Description |
|------------|----------------|--------------|
| `appServiceName` | `yourcompanyname-inrule-salesforce` | The name for the Azure App Service that hosts the Salesforce Rule Execution API. |
| `sfLoginUrl` | `https://login.salesforce.com/services/oauth2/token` | Login URL for your Salesforce instance used with the integration framework. |
| `sfUsername` | `salesforce_user@yourcompany.com` | Salesforce username used to authenticate the API connection. |
| `sfPassword` | `password` | Password for the Salesforce user account. |
| `sfSecurityToken` | `<security-token>` | API security token for the Salesforce service account. |
| `sfConsumerKey` | `<consumer-key>` | OAuth consumer key for the Salesforce connected app. |
| `sfConsumerSecret` | `<consumer-secret>` | OAuth consumer secret for the Salesforce connected app. |
| `catalogUri` | `https://{catalogAppService}.azurewebsites.net/Service.svc/core` | URI for your InRule Rule Catalog Service. |
| `catalogUser` | `admin` | Username for authenticating to the InRule Catalog Service. |
| `catalogPassword` | `password` | Password for the InRule Catalog Service user. |
| `ruleAppLabel` | `LIVE` | The label of the Rule Application to be executed by the Salesforce API. |
| `appServicePlanName` | `inruleSalesforcePlan` | Name of the App Service Plan. Leave blank to derive from `appServiceName` + `Plan`. |
| `createOrUpdateAppServicePlan` | `true` | Indicates whether to create or update the App Service Plan. |
| `inRuleVersion` | `5.9.0` | Version of InRule to deploy. Defaults to the latest if not specified. |
| `appInsightsConnectionString` | `InstrumentationKey=<key>;IngestionEndpoint=https://<region>.in.applicationinsights.azure.com/` | Connection string for Azure Application Insights integration. |
| `primaryApiKey` | `<key>` | Primary API key used to authenticate with the Salesforce Rule Execution API. |
| `secondaryApiKey` | `<key>` | Secondary API key used as a backup for the Salesforce Rule Execution API. |

> **Tip:** Save a copy of this parameters file after deployment to reuse for future upgrades.

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
# Example: az group create --name inrule-salesforce-rg --location eastus
az group create --name RESOURCE_GROUP_NAME --location LOCATION
```

## Execute the following command to deploy the ARM template
Replace __RESOURCE_GROUP_NAME__ with the name of the Azure Resource Group you want to deploy to:
```powershell
az deployment group create -g RESOURCE_GROUP_NAME --template-file .\InRule.Salesforce.Service.json --parameters .\InRule.Salesforce.Service.parameters.json
```

## Upload valid license file
In order for the Salesforce API to properly function, a valid license file must be uploaded to the web app. For information on how to upload your license file please refer to our [license upload documentation](/doc/upload-license-file.md).

## Verify by getting status details
As a final verification that the Salesforce Rule Execution Service is properly functioning, a REST call can be made to the status details endpoint.

Get status details from your Salesforce instance:
```powershell
Invoke-RestMethod -Method 'Get' -ContentType 'application/json' -Headers @{"Accept"="application/json"; "inrule-apikey"="YOUR_API_KEY"} -Uri https://WEB_APP_NAME.azurewebsites.net/api/status/liveness
```

If the request was successful, you should get a `200` response back.

# Execution of Rules
After deployment, you have different options on how to execute rules. For detailed instructions on executing rules and decisions,
visit our [InRule for Salesforce](https://docs.inrule.com/docs/inrule-for-salesforce) documentation.
