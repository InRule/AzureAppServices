nRule® for Microsoft Azure
====

InRule _for Microsoft Azure_ allows you to run [irCatalog](https://www.inrule.com/products/inrule-components/ircatalog/), irCatalog Manager Website, and [irServer Rule Execution Service](https://www.inrule.com/products/inrule-components/irserverruleexecutionservice/) inside of the Azure App Service environment with minimal configuration and setup. If you are already familiar with Azure and App Service Web Apps, then you are just a few steps away from deploying InRule _for Microsoft Azure_.

# Prerequisites

Before you get started, you'll need the make sure you have the following:

* Knowledge and familiarity with Microsoft Azure, specifically around [Azure Resource Management](https://docs.microsoft.com/en-us/azure/azure-resource-manager/), [Azure App Service Web Apps](https://docs.microsoft.com/en-us/azure/app-service/), and [Azure SQL Databases](https://docs.microsoft.com/en-us/azure/sql-database/).

* A Microsoft Azure Subscription. If you do not have an Azure subscription, create a [free account](https://azure.microsoft.com/en-us/free/) before you begin.

* A valid InRule license file, usually named `InRuleLicense.xml`. If you do not have a valid InRule license file for InRule _for Microsoft Azure_, please contact [Support](mailto:support@inrule.com?subject=InRule®%20for%20Microsoft%20Azure%20-%20App%20Service%20Web%20Apps).

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) version 2.0.21 or later is installed. To see which version you have, run `az --version` command in your terminal window.

* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting) version 3.0 or later is installed. To see which version you have, run `$PSVersionTable.PSVersion.ToString()` command in your PowerShell terminal window.

# irCatalog and irCatalog Manager

irCatalog® is a business rule management tool that provides centralized management of rules to ensure the integrity of business rules, keep everyone working on the latest version of rules, and promote sharing of common rules across customers, processes or applications.

The Catalog Manager is a stand-alone web application that provides an administrative interface to an irCatalog repository. It is used to manage and migrate Rule Applications across an organization's various staging environments including production. It also provides an interface for managing users, roles, and permissions.

There are two options for deploying the Catalog and Catalog Manager, deploying with an Azure Resource Manager Template or deploying resources individually via the Azure CLI. Both options will deploy the same set of resources, but the ARM template deploys them all in a single step.

#### Deploying via Azure Resource Manager Template:

* [ARM Template Deployment](doc/ircatalog-arm-template-deployment.md)

#### Deploying with manual steps:

* [Database Deployment](doc/ircatalog.md)
* [irCatalog Web App Deployment](doc/ircatalog.md#web-app-deployment)
* [irCatalog Manager Web App Deployment](doc/ircatalog-manager.md)

# irServer Rule Execution Service

With irServer® Rule Execution Service, you can call business rules from a variety of systems including J2EE applications, BPM processes and ESB orchestrations. Execute any rules stored in irCatalog or in the App Service Web App itself. Access is available via REST or SOAP.

There are two options for deploying the Execution Service, deploying with an Azure Resource Manager Template or deploying resource individually via the Azure CLI. Both options will deploy the same set of resources, but the ARM template deploys them all in a single step.

#### Deploying via Azure Resource Manager Template:

* [ARM Template Deployment](doc/irserver-arm-template-deployment.md)

#### Deploying with manual steps:

* [irServer Web App Deployment](doc/irserver-rule-execution-service.md)

For more information on rules execution, refer to the following links:
* [Execution of Rules](doc/irserver-rule-execution-service.md#execution-of-rules)
* [SDK Developer Guide](https://support.inrule.com/help/irSDKHelp50/index.html?irsoa_-_rules_as_services.htm)

# Log retrieval
Once Web Apps have been deployed, their individual log files can be retrieved.

* [Web App log retrieval](doc/webapp-log-retrieval.md)





