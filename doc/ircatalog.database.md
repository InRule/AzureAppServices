irCatalog Database
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

## Create Database Server
Create the [Azure SQL Server](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-logical-servers) command:
```powershell
# Example: az sql server create --location eastus --resource-group inrule-prod-rg --name ircatalog-server --admin-user admin --admin-password %14TVpB*g$4b
az sql server create --location LOCATION --resource-group RESOURCE_GROUP_NAME --name SERVER_NAME --admin-user ADMIN_USER_NAME --admin-password ADMIN_USER_PASSWORD
```

## Create Database
Create the [Azure SQL Server Database](https://docs.microsoft.com/en-us/azure/sql-database/sql-database-single-databases-manage) command:
```powershell
# Example: az sql db create --name ircatalog-database --server ircatalog-server --resource-group ehertlein --service-objective S0
az sql db create --name DATABASE_NAME --server SERVER_NAME --resource-group RESOURCE_GROUP_NAME --service-objective S0
```

## Create Database Server Firewall Rules
```powershell
# Example: az sql server firewall-rule create --resource-group inrule-prod-rg --server ircatalog-server --name myLocalMachine --start-ip-address 1.2.3.4 --end-ip-address 1.2.3.4
az sql server firewall-rule create --resource-group RESOURCE_GROUP_NAME --server SERVER_NAME --name FIREWALL_RULE_NAME --start-ip-address MY_EXTERNAL_IP --end-ip-address MY_EXTERNAL_IP
```

## Run the Catalog Creation Application
Update the appsettings.json with the connection string from your database. Be sure to set a valid user name and password.
```powershell
# Example: az sql db show-connection-string --server ircatalog-server --name ircatalog-database --client ado.net
az sql db show-connection-string --server cattest2 --name cattest2db --client ado.net
```

Run the included executable to create the initial InRule Catalog schema.
```powershell
.\InRule.Catalog.Service.Database.exe
```
