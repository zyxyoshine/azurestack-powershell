$loadEnvPath = Join-Path $PSScriptRoot 'loadEnv.ps1'
if (-Not (Test-Path -Path $loadEnvPath)) {
    $loadEnvPath = Join-Path $PSScriptRoot '..\loadEnv.ps1'
}
. ($loadEnvPath)

$TestRecordingFile = Join-Path $PSScriptRoot 'Remove-AzsGalleryItem.Recording.json'
$currentPath = $PSScriptRoot
while(-not $mockingPath) {
    $mockingPath = Get-ChildItem -Path $currentPath -Recurse -Include 'HttpPipelineMocking.ps1' -File
    $currentPath = Split-Path -Path $currentPath -Parent
}
. ($mockingPath | Select-Object -First 1).FullName

Describe 'Remove-AzsGalleryItem' {
    it "TestCreateAndDeleteGalleryItemPiped" {
        $global:TestName = 'TestCreateAndDeleteGalleryItem'

        $name = "TestUbuntu.Test.1.0.0"
        $uri = "https://testsa.blob.redmond.ext-n35r1010.masd.stbtest.microsoft.com/testsc/TestUbuntu.Test.1.0.0.azpkg"
        Remove-AzsGalleryItem -Name $name 

        $GalleryItem = Add-AzsGalleryItem -GalleryItemUri $uri 
        $GalleryItem | Should Not Be $null
        #write-host ($GalleryItem | Format-List | Out-String)
        Write-Host "******* DEFAULT VALUES *******"
        write-host ($PSDefaultParameterValues | Format-List | Out-String)
        Write-Host ($PSBoundParameters | Format-List | Out-String)
        $params = @{}
        if ($PSDefaultParameterValues.ContainsKey('SubscriptionId')){
            $params.Add('SubscriptionId', $SubscriptionId)
        }
        Write-Host "NAME : $name"
        Write-Host "params : $($params.Values)"
       # $ipObject = Get-AzsGalleryItem -Name $name @params
        Remove-AzsGalleryItem -Name $name #-InputObject $ipObject @params
    }
}
