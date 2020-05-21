$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}

Write-Host "loadenvpath: $loadEnvPath"
Get-Content -Path $loadEnvPath | Write-Host

. ($loadEnvPath)

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
