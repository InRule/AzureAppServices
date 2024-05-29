InRule Cloud Deployment Options for Microsoft Azure
====
InRule provides cloud deployment options that allow you to run irCatalog, irCatalog Manager Website, and [Decision Services](https://support.inrule.com/hc/en-us/articles/13140368354445-Introduction-to-Decision-Services) inside of the Microsoft Azure App Service environment with minimal configuration and setup. For a store-front UI enabled deployment experience, visit our InRule Decision Services [marketplace listing](). For additional information on other deployment options and their repsective deployment process, please see below.

# Prerequisites

Before you get started, you'll need to make sure you have the following:

* Knowledge and familiarity with Microsoft Azure, specifically around [Azure Resource Management](https://docs.microsoft.com/en-us/azure/azure-resource-manager/), [Azure App Service Web Apps](https://docs.microsoft.com/en-us/azure/app-service/), and [Azure SQL Databases](https://docs.microsoft.com/en-us/azure/sql-database/).

* A Microsoft Azure Subscription. If you do not have an Azure subscription, create a [free account](https://azure.microsoft.com/en-us/free/) before you begin.

* A valid InRule license file, usually named `InRuleLicense.xml`. If you do not have a valid InRule license file for InRule, please contact [Support](mailto:support@inrule.com?subject=InRule®%20for%20Microsoft%20Azure%20-%20App%20Service%20Web%20Apps).

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) is installed.

* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting) is installed.

# irCatalog and irCatalog Manager

irCatalog is a business rule management tool that provides centralized management of rules to ensure the integrity of business rules, keep everyone working on the latest version of rules, and promote sharing of common rules across customers, processes or applications.

The Catalog Manager is a stand-alone web application that provides an administrative interface to an irCatalog repository. It is used to manage and migrate Rule Applications across an organization's various staging environments including production. It also provides an interface for managing users, roles, and permissions.

There are two options for deploying the Catalog and Catalog Manager, deploying with an Azure Resource Manager Template or deploying resources individually via the Azure CLI. Both options will deploy the same set of resources, but the ARM template deploys them all in a single step.

#### Deploying via Azure Resource Manager Template:

* [ARM Template Deployment](doc/ircatalog-arm-template-deployment.md)

#### Deploying with manual steps:

* [Database Deployment](doc/ircatalog.md)
* [irCatalog Web App Deployment](doc/ircatalog.md#web-app-deployment)
* [irCatalog Manager Web App Deployment](doc/ircatalog-manager.md)

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

# Legacy irServer Rule Execution Service

For more information regarding the irServer Excution Service, you can visit the documentation [here](doc/irserver-rule-execution-service.md). For instructions on deploying the irServer Execution Service with an ARM template, see the documentation [here](doc/ircatalog-arm-template-deployment.md).


_InRule, InRule Technology, irAuthor, irVerify, irServer, irCatalog, irSDK and  irX are registered trademarks of InRule Technology, Inc. irDistribution and irWord are trademarks of InRule Technology, Inc. All other trademarks and trade names mentioned herein may be the trademarks of their respective owners and are hereby acknowledged._