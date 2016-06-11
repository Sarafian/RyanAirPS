& "$PSScriptRoot\..\ISEScripts\Reset-Module.ps1"

$exportedNames=Get-Command -Module RyanAirPS | Select-Object -ExcludeProperty Name

. "$PSScriptRoot\Version.ps1"
$semVersion=Get-Version

$author="Alex Sarafian"
$company=""
$copyright="(c) $($date.Year) $company. All rights reserved."
$description="A module to help with RyanAir API"

$modules=Get-ChildItem "$PSScriptRoot\..\Modules\"

foreach($module in $modules)
{
    Write-Host "Processing $module"
    $name=$module.Name

    $psm1Name=$name+".psm1"
    $psd1Name=$name+".psd1"
    $psd1Path=Join-Path $module.FullName $psd1Name

    $guid="035a9a53-9bd7-4634-8349-d7e72bedd241"
    $hash=@{
        "Author"=$author
        "Copyright"=$copyright
        "RootModule"=$psm1Name
        "Description"=$description
        "Guid"=$guid
        "ModuleVersion"=$semVersion
        "Path"=$psd1Path
        "Tags"=@('RyanAirPS', 'Tools')
        "LicenseUri"='https://github.com/Sarafian/RyanAirPS/blob/master/LICENSE'
        "ProjectUri"= 'http://github.com/Sarafian/RyanAirPS/'
        "IconUri" ='https://github.com/Sarafian/RyanAirPS/blob/master/RyanAir.jpg'
        "ReleaseNotes"= 'https://github.com/Sarafian/RyanAirPS/blob/master/CHANGELOG.md'
        "CmdletsToExport" = $exportedNames
        "FunctionsToExport" = $exportedNames
    }

    New-ModuleManifest  @hash 
}