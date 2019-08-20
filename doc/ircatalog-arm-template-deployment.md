irCatalog and irCatalog Manager Arm Template Deployment
====
In this section we will be deploying the irCatalog® as well as the irCatalog Manager.  This will create a databse and two app services.  To make this process easier, we'll be using an Azure Resource Manager (ARM) template, which allows us to deploy and configure all the Azure resources needed for both the irCatalog and irCatalog Manager.

If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

The arm template can be downloaded [here](../InRule.Catalog.Service.json) and the parameters file [here](../InRule.Catalog.Service.parameters.json). Both will be needed to continue with this deployment option.

# Update the template parameters

Before deploying the ARM template, we need to define certain parameters.

Locate the _InRule.Catalog.Service.parameters.json_ file you dowloaded above.

Open the file with your text editor of choice and edit the parametes listed below:

#### InRule.Catalog.Service.parameters.json
| Parameter | Example Values | Description |
| --------- | ------------- | ----------- |
| catalogServiceName | catalogAppService | Provide a name for the Azure App Service that the catalog service will run on. |
| catalogManagerServiceName | catalogManagerAppService | Provide a name for the Azure App Service that the catalog manager service will run on. |
| catalogServicePlanSkuName | B1 | Describes catalog services plan's pricing tier and capacity. [Plan Details](https://azure.microsoft.com/en-us/pricing/details/app-service/)|
| catalogSqlServerName | catalogSqlDbServerName | The server name for the Azure SQL server used to host the irCatalog database(s). |
| catalogSqlServerUsername | sqlDbServerUser | The server admin username for the Azure SQL server used to host the irCatalog database(s). |
| catalogSqlServerPassword | sqlDbServerPassword | The server admin password for the Azure SQL server used to host the irCatalog database(s). |
| catalogSqlDbName | catalogSqlDbName | The name for the irCatalog database. |
| catalogSqlDbEdition | Basic | The Azure SQL database edition used for the irCatalog database. Use Basic for less demanding workloads, Standard for most production workloads, and Premium for IO-intensive workloads. |
| catalogSqlDbPerformanceLevel | Basic | The Azure SQL database performance level for the irCatalog. These correspond to the specific Azure SQL database edition. |
| inRuleVersion | 5.4.1 | Provide the inRule version you wish to deploy, default value is the latest inRule version. |

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
az group deployment create -g RESOURCE_GROUP_NAME --template-file .\InRule.Catalog.Service.json --parameters .\InRule.Catalog.Service.parameters.json
```

## Allow Your Local Machine Access via Firewall Rule
You'll need to temporarily allow access to your local machine to deploy the schema and data for the database. This step can be found in the irCatalog web app deployment guide [irCatalog Web App Deployment](ircatalog.md#allow-ircatalog-server-access-via-firewall-rule)

## Deploy the irCatalog Database
After opening the firewall, you'll need to use the provided tool to setup the database. This step can be found in the irCatalog web app deployment guide [irCatalog Web App Deployment](ircatalog.md#deploy-the-ircatalog-database)

## Upload valid license file
In order for irCatalog Service to properly function, a valid license file must be uploaded to the web app. The simplest way to upload the license file is via FTP.

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

## Verify using irAuthor
Using irAuthor you should now be able to connect to your catalog using the url [https://catalogServiceName.azurewebsites.net/service.svc](https://catalogServiceName.azurewebsites.net/service.svc).
