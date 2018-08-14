InRule® for Microsoft Azure - App Service Web Apps
====

InRule _for Microsoft Azure_ allows you to run [irCatalog](https://www.inrule.com/products/inrule-components/ircatalog/) and [irServer](https://www.inrule.com/products/inrule-components/irserverruleexecutionservice/) Rule Execution Service inside of Azure's Platform as a Service (PaaS) with minimal configuration and setup. If you are already familiar with Azure and App Service Web Apps, then you are just a few steps away from deploying InRule _for Microsoft Azure_.

# Prerequisites

Before you get started, you'll need the make sure you have the following:

* Knowledge and familiarity with Microsoft Azure, specifically around [Azure Resource Management](https://docs.microsoft.com/en-us/azure/azure-resource-manager/), [Azure App Service Web Apps](https://docs.microsoft.com/en-us/azure/app-service/), and [Azure SQL Databases](https://docs.microsoft.com/en-us/azure/sql-database/).

* A Microsoft Azure Subscription. If you do not have an Azure subscription, create a [free account](https://azure.microsoft.com/en-us/free/) before you begin.

* A valid InRule license file, usually named `InRuleLicense.xml`. If you do not have a valid InRule license file for InRule _for Microsoft Azure_, please contact [Support](mailto:support@inrule.com?subject=InRule®%20for%20Microsoft%20Azure%20-%20App%20Service%20Web%20Apps).

* [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) version 2.0.21 or later is installed. To see which version you have, run `az --version` command in your terminal window.

* [PowerShell](https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting) version 3.0 or later is installed. To see which version you have, run `$PSVersionTable.PSVersion.ToString()` command in your PowerShell terminal window.

# irServer Rule Execution Service

With irServer® Rule Execution Service, you can call business rules from a variety of systems including J2EE applications, BPM processes and ESB orchestrations. Execute any rules stored in irCatalog or in the App Service Web App itself. Access is available via REST or SOAP.

* [Web App Deployment](doc/irserver-rule-execution-service.md)
* [Execution of Rules](doc/irserver-rule-execution-service.md#execution-of-rules)
* [SDK Developer Guide](https://support.inrule.com/help/irSDKHelp50/index.html?irsoa_-_rules_as_services.htm)

# irCatalog

irCatalog® is a business rule management tool that provides centralized management of rules to ensure the integrity of business rules, keep everyone working on the latest version of rules, and promote sharing of common rules across customers, processes or applications.

* [Database Deployment](doc/ircatalog.md)
* [Web App Deployment](doc/ircatalog.md#web-app-deployment)

# irCatalog Manager

The Catalog Manager is a stand-alone web application that provides an administrative interface to an irCatalog repository.  It is used to manage and migrate Rule Applications across an organization's various staging environments including production. It also provides an interface for managing users, roles, and permissions.

* [Web App Deployment](doc/ircatalog-manager.md)

# Log retrieval
Once Web Apps have been deployed, their individual log files can be retrieved.

* [Web App log retrieval](doc/webapp-log-retrieval.md)




