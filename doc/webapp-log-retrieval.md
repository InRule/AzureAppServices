Web App Log Retrieval
====

You can retrieve the logs from your individual InRule App Service Web Apps via the Azure CLI.

## Getting started

Before retrieving Web App logs, follow the steps below to log into Azure:

* [Sign in to Azure](deployment-getting-started.md#sign-in-to-azure)
* [Set active subscription](deployment-getting-started.md#set-active-subscription)

## Retrieve logs from desired Web App
Retrieve a zip file of logs from a specified Web App, with the [az webapp log download](https://docs.microsoft.com/en-us/cli/azure/webapp/log?view=azure-cli-latest#az-webapp-log-download) command:
```powershell
#Example az webapp log download --name ircatalog-server --resource-group inrule-prod-rg
az webapp log download --name WEB_APP_NAME --resource-group RESOURCE_GROUP 
```
