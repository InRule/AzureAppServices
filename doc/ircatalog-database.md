irCatalog Database
====
If you have not done so already, please read the [prerequisites](../README.md#prerequisites) before you get started.

# Deployment

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
Create the resource group that will contain the InRule-related Azure resources with the [az group create](https://docs.microsoft.com/en-us/cli/azure/group#az-group-create) command:
```powershell
# Example: az group create --name inrule-prod-rg --location eastus
az group create --name RESOURCE_GROUP_NAME --location LOCATION
```

## Create Database Server
Create the [Azure SQL Server](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-logical-servers) with the [az sql server create](https://docs.microsoft.com/en-us/cli/azure/sql/server?view=azure-cli-latest#az-sql-server-create) command:
```powershell
# Example: az sql server create --location eastus --resource-group inrule-prod-rg --name ircatalog-server --admin-user admin --admin-password %14TVpB*g$4b
az sql server create --location LOCATION --resource-group RESOURCE_GROUP_NAME --name SERVER_NAME --admin-user ADMIN_USER_NAME --admin-password ADMIN_USER_PASSWORD
```

## Create Database
Create the [Azure SQL Server Database](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-single-databases-manage) with the [az sql db create](https://docs.microsoft.com/en-us/cli/azure/sql/db?view=azure-cli-latest#az-sql-db-create) command:
```powershell
# Example: az sql db create --name ircatalog-database --server ircatalog-server --resource-group inrule-prod-rg
az sql db create --name DATABASE_NAME --server SERVER_NAME --resource-group RESOURCE_GROUP_NAME
```

## Allow Access via Firewall Rule
In order to run the catalog database install/upgrade application, a firewall rule must be added to allow your local machine access to the Azure SQL Server.

Create a rule in the firewall to allow you to access the newly created database with the [az sql server firewall-rule create](https://docs.microsoft.com/en-us/cli/azure/sql/server/firewall-rule?view=azure-cli-latest#az-sql-server-firewall-rule-create) command:
```powershell
# Example: az sql server firewall-rule create --name myLocalMachine --server ircatalog-server --resource-group inrule-prod-rg --start-ip-address 1.2.3.4 --end-ip-address 1.2.3.4
az sql server firewall-rule create --name FIREWALL_RULE_NAME --server SERVER_NAME --resource-group RESOURCE_GROUP_NAME --start-ip-address MY_EXTERNAL_IP --end-ip-address MY_EXTERNAL_IP
```

## Deploy the irCatalog Database
First, [download](https://github.com/InRule/AzureAppServices/releases/latest) the latest irCatalog Database package (`InRule.Catalog.Service.Database.zip`) from GitHub, and unzip into a directory of your choosing.

Update the `appsettings.json` found in the newly unzipped directory with the connection string for your database. Be sure to set a valid user name and password. You can retrieve the connection string with the [az sql db show-connection-string](https://docs.microsoft.com/en-us/cli/azure/sql/db?view=azure-cli-latest#az-sql-db-show-connection-string) command:
```powershell
# Example: az sql db show-connection-string --server ircatalog-server --name ircatalog-database --client ado.net
az sql db show-connection-string --server SERVER_NAME --name DATABASE_NAME --client ado.net
```

Then run the included executable to deploy the initial irCatalog database schema:
```powershell
.\InRule.Catalog.Service.Database.exe
```

## (Optional) Remove Firewall Rule
While not required, the firewall rule that was added earlier may be removed with the [az sql server firewall-rule delete](https://docs.microsoft.com/en-us/cli/azure/sql/server/firewall-rule?view=azure-cli-latest#az-sql-server-firewall-rule-delete) command:
```powershell
# Example: az sql server firewall-rule delete --name myLocalMachine --server ircatalog-server --resource-group inrule-prod-rg
az sql server firewall-rule delete --name FIREWALL_RULE_NAME --server SERVER_NAME --resource-group RESOURCE_GROUP_NAME
```
