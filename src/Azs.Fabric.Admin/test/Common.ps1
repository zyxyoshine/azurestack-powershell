$global:SkippedTests = @(
)
<#
if ($global:TestMode -eq "Live") {
    $location = Get-AzLocation
    if ($location.GetType().BaseType.Name -eq "Array")
    {
        $global:Location = $location[0].DisplayName
        $global:ResourceGroupName = -join("System.", $global:Location)
    }
    else
    {
        $global:Location = $location.DisplayName
        $global:ResourceGroupName = -join("System.", $global:Location)
    }
}
else {
    $global:Location = "redmond"
    $global:ResourceGroupName = "System.redmond"
}#>
