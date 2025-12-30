<#
.SYNOPSIS
    Converts an InRule license XML file to a data URI format for use with environment variables.

.DESCRIPTION
    This script reads an InRule license XML file, minimizes it (removes unnecessary whitespace),
    base64 encodes it, and outputs a data URI that can be used with the inrule__license
    environment variable in Azure App Services deployments.

.PARAMETER LicenseFilePath
    The path to the InRuleLicense.xml file.

.EXAMPLE
    .\Convert-LicenseToDataUri.ps1 -LicenseFilePath "C:\path\to\InRuleLicense.xml"
    
    Outputs the data URI to the console.

.NOTES
    The output data URI can be used as the value for:
    - ARM template parameter: catalogLicenseKey or executionLicenseKey
    - Azure App Service environment variable: inrule__license
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "Path to the InRuleLicense.xml file")]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$LicenseFilePath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$stringWriter = $null
$xmlWriter = $null

try {
    # Read the XML file
    Write-Verbose "Reading license file: $LicenseFilePath"
    Write-Host "Reading license file: $LicenseFilePath" -ForegroundColor Cyan
    $xmlContent = Get-Content -Path $LicenseFilePath -Raw -Encoding UTF8

    # Validate and load the XML
    try {
        $xml = [xml]$xmlContent
    }
    catch {
        throw "The file is not valid XML: $_"
    }

    # Minimize the XML (removes whitespace between elements)
    $stringWriter = New-Object System.IO.StringWriter
    $xmlWriterSettings = New-Object System.Xml.XmlWriterSettings
    $xmlWriterSettings.Indent = $false
    $xmlWriterSettings.OmitXmlDeclaration = $false
    $xmlWriterSettings.Encoding = [System.Text.Encoding]::UTF8
    
    $xmlWriter = [System.Xml.XmlWriter]::Create($stringWriter, $xmlWriterSettings)
    $xml.Save($xmlWriter)
    $xmlWriter.Flush()
    $minimizedXml = $stringWriter.ToString()

    Write-Host "Original size: $($xmlContent.Length) characters" -ForegroundColor Gray
    Write-Host "Minimized size: $($minimizedXml.Length) characters" -ForegroundColor Gray

    # Convert to Base64
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($minimizedXml)
    $base64 = [Convert]::ToBase64String($bytes)

    # Create data URI
    $dataUri = "data:application/xml;base64,$base64"

    Write-Host "`nData URI generated successfully!" -ForegroundColor Green
    Write-Host "Data URI length: $($dataUri.Length) characters" -ForegroundColor Gray
    Write-Host "`n--- Data URI (copy the entire string below) ---`n" -ForegroundColor Yellow
    
    Write-Output $dataUri

    Write-Host "`n--- End of Data URI ---`n" -ForegroundColor Yellow

    Write-Host @"

Usage Instructions:
-------------------
1. For ARM template deployment, use this value for the license parameter:
   - catalogLicenseKey (for Catalog Service)
   - executionLicenseKey (for Decision Service, Dynamics, or Salesforce)

2. For manual Azure App Service configuration, set the environment variable:
   - Name: inrule__license
   - Value: <the data URI above>

"@ -ForegroundColor Cyan

}
catch {
    Write-Error "Failed to convert license file: $_"
    exit 1
}
finally {
    if ($null -ne $xmlWriter) {
        $xmlWriter.Dispose()
    }
    if ($null -ne $stringWriter) {
        $stringWriter.Dispose()
    }
}
