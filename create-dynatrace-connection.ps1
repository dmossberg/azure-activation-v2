$environment = "$($Env:dynatraceEnvironment ?? 'dev')"
$endpoint = "https://$Env:dynatraceTenant.$environment.dynatracelabs.com/api/v2/settings/objects?validateOnly=false&adminAccess=false"

$jsonBody = @"
[
    {
        "value": {
            "azureClientSecret": {
                "directoryId": "$($Env:directoryId)",
                "applicationId": "$($Env:clientId)",
                "clientSecret": "$($Env:clientSecret)",
                "consumers": ["DA"]
            },
            "name": "Dynatrace Azure Monitoring ($($Env:subscriptionId))",
            "type": "clientSecret"
        },
        "schemaVersion": "0.0.1",
        "schemaId": "builtin:hyperscaler-authentication.connections.azure"
    }
]
"@

try
{
    $response = Invoke-WebRequest -SkipCertificateCheck `
        -ContentType "application/json" `
        -Method POST `
        -Uri $endpoint `
        -Headers @{
            "Accept" = "application/json"
            "Authorization" = "Api-Token $Env:dynatraceApiKey"
        } `
        -Body ($jsonBody)

    if ($response.StatusCode -eq 200) {
        $jsonResponse = $response.Content | ConvertFrom-Json
        $DeploymentScriptOutputs = @{}
        $DeploymentScriptOutputs['hyperscalerAuthServiceObjectId'] = $jsonResponse[0].objectId
        Write-Output $DeploymentScriptOutputs['hyperscalerAuthServiceObjectId']
    } else {
        throw "Request failed with status code: $($response)"
    }
}
catch {
    throw "Request failed with status code: $($_.ErrorDetails.Message)"
}