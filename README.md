InRule Cloud Deployment Options for Microsoft Azure
====
InRule provides cloud deployment options that allow you to run Catalog, Catalog Manager, and [Decision Services](https://support.inrule.com/hc/en-us/articles/13140368354445-Introduction-to-Decision-Services) inside of the Microsoft Azure App Service environment with minimal configuration and setup. For a store-front UI enabled deployment experience, visit the InRule Decision Services [marketplace listing](https://azuremarketplace.microsoft.com/en-us/marketplace/apps/inruletechnology-1043512.inrule-execution). For additional information on other deployment options and their respective deployment process, please see below.

# Prerequisites

Before you get started, you'll need to make sure you have the following:

* Knowledge and familiarity with Microsoft Azure, specifically around [Azure Resource Management](https://docs.microsoft.com/en-us/azure/azure-resource-manager/), [Azure App Service Web Apps](https://docs.microsoft.com/en-us/azure/app-service/), and [Azure SQL Databases](https://docs.microsoft.com/en-us/azure/sql-database/).

* A Microsoft Azure Subscription. If you do not have an Azure subscription, create a [free account](https://azure.microsoft.com/en-us/free/) before you begin.

* A valid InRule license file, named __`InRuleLicense.xml`__. If you do not have a valid InRule license file for InRule, please contact [Support](mailto:support@inrule.com?subject=InRule®%20for%20Microsoft%20Azure%20-%20App%20Service%20Web%20Apps).

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) is installed.


# Catalog and Catalog Manager

InRule’s catalog provides centralized rule management and administration to store, version, set permissions, check-in and check-out rules—all at a granular level. The Catalog Manager makes it easy to promote rules from one environment to another.

The Catalog Manager is a stand-alone web application that provides an administrative interface to an Catalog repository. It is used to manage and migrate Rule Applications across an organization's various staging environments including production. It also provides an interface for managing users, roles, and permissions.


#### Deploying via Azure Resource Manager Template:

* [ARM Template Deployment](doc/ircatalog-arm-template-deployment.md)


# Decision Services

InRule is proud to release its latest APIs for discoverable and frictionless execution of decisions and rules. Decision Services are provided as two APIs-in-one including the newly designed [Decision API](https://support.inrule.com/hc/en-us/articles/17532346873101-Decision-API) and a modernized version of our classic [Rule Execution API](https://support.inrule.com/hc/en-us/articles/13377054188557-Rule-Execution-API).

There are two options for deploying Decision Services: deploying through the Azure Marketplace or deploying with an Azure Resource Manager Template - both options will deploy the same set of resources. If deploying with the ARM template, you can choose to deploy via the [Azure Portal](https://portal.azure.com/#create/Microsoft.Template) or through the Azure CLI.

#### Deploying via Azure Resource Manager Template:

* [ARM Template Deployment](doc/decision-services-arm-template-deployment.md)

# Decision and Rule Execution
For more information on executing decisions and rules, refer to the following documentation:
* [Decision Services API Guide](https://support.inrule.com/hc/en-us/articles/13140368354445-Introduction-to-Decision-Services)

# Log retrieval
Once Web Apps have been deployed, their individual log files can be retrieved.

* [Web App log retrieval](doc/webapp-log-retrieval.md)

# Upgrade Considerations
Be sure to backup the AppSettings file because it will be overwritten for an upgrade deployment.

# Legacy irServer Rule Execution Service

For instructions on deploying the irServer Execution Service with an ARM template, see the documentation [here](https://github.com/InRule/AzureAppServices/blob/master/doc/irserver-arm-template-deployment.md).