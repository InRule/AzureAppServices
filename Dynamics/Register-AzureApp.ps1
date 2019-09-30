<#
.SYNOPSIS
	Registers an application in Azure AD for authenticating the InRule Integration Framework with Dynamics CRM
.DESCRIPTION
	Use this script if you plan on using Server-to-Server authentication with an application user instead of a regular service account for communication from the InRule integration framework to Dynamics CRM.
	This script will register an application in Azure AD, and create an authentication key and service principal for access
	The app ID and key secret will be output at the end of the script. Please save these values for configuration of the InRule Rule Execution Service later
.PARAMETER Username 
	Azure AD username for a user with Global Administrator privileges
	This is an optional paramter; if not included, interactive login will be used
.PARAMETER Password
	Password for the provided username
	This is an optional paramter; if not included, interactive login will be used
.PARAMETER TenantId
	The Azure AD tenant to create register the app in
	This is an optional parameter; if not included, the user's default tenant will be used
.EXAMPLE
	.\Register-AzureApp.ps1 -User
.NOTES
	This script requires the Azure Active Directory PowerShell module. If it is not yet installed, you can install it by running 'Install-Module AzureAD' at an elevated PowerShell prompt
#>

param(
	[string]$Username,
	[string]$Password,
	[string]$TenantId
)
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
$erroractionpreference = "Continue"

$appName = "InRuleDynamicsCrmIntegration"
$appURI = "https://InRuleDynamicsCrmIntegration.azurewebsites.net"
	
if ($Username -and $Password)
{
	$securePW = ConvertTo-SecureString -String $Password -AsPlainText -Force
	$creds = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $securePw

	if (!$TenantId)
	{
		Connect-AzureAD -Credential $creds
	}
	else 
	{
		Connect-AzureAD -Credential $creds -TenantId $TenantId
	}
}
else
{
	if (!$TenantId)
	{
		Connect-AzureAD
	}
	else 
	{
		Connect-AzureAD -TenantId $TenantId
	}
}
		
if(!($myApp = Get-AzureADApplication -Filter "DisplayName eq '$($appName)'"  -ErrorAction SilentlyContinue))
{
	$startDate = Get-Date
	$endDate = "2099-01-01T13:45:30"

	$myApp = New-AzureADApplication -DisplayName $appName -IdentifierUris $appURI

	$aadAppKeyPwd = New-AzureADApplicationPasswordCredential -ObjectId $myApp.ObjectId -CustomKeyIdentifier "Primary" -StartDate $startDate -EndDate $endDate

	New-AzureADServicePrincipal -AppId $myApp.AppId

	$appDetailsOutput = "Application Details for the $appName application:
	=========================================================
	Application Name: 	$appName
	Application Id:   	$($myApp.AppId)
	Secret Key:       	$($aadAppKeyPwd.Value)
	"
		Write-Host
		Write-Host $appDetailsOutput
}
else
{
	Write-Host
	Write-Host -f Yellow Azure AD Application $appName already exists.

	$appDetailsOutput = "Application Details for the $appName application:
	=========================================================
	Application Name: 	$appName
	Application Id:   	$($myApp.AppId)
	"
		Write-Host
		Write-Host $appDetailsOutput
}
