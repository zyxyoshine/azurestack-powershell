# Load Default parameter values

$envFile = 'env.json'
Write-Host "Loading env.json"
if ($TestMode -eq 'live') {
    $envFile = 'localEnv.json'
}

if (Test-Path -Path (Join-Path $PSScriptRoot $envFile)) {
    $envFilePath = Join-Path $PSScriptRoot $envFile
} else {
    $envFilePath = Join-Path $PSScriptRoot '..\$envFile'
}
$env = @{}
if (Test-Path -Path $envFilePath) {
    $env = Get-Content (Join-Path $PSScriptRoot $envFile) | ConvertFrom-Json
    Write-Host "******In loadenv.ps1******"
    Write-Host $env.Values
    $PSDefaultParameterValues=@{"*:SubscriptionId"=$env.SubscriptionId; "*:Tenant"=$env.Tenant}
    $PSDefaultParameterValues.Add("*:Location", $env.Location)
    Write-Host "Default values: $($PSDefaultParameterValues.Values)"
}

Write-Host "Default parameter values"
Write-Host "Default values: $($PSDefaultParameterValues.Values)"
$TestRecordingFile = Join-Path $PSScriptRoot 'Get-AzsKeyvaultQuota.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'Get-AzsKeyvaultQuota' {
    It 'List' {
        $quotas = Get-AzsKeyvaultQuota
        $quotas | Should -Not -BeNullOrEmpty    
    }
}
