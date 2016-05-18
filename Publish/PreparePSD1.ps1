& "$PSScriptRoot\..\ISEScripts\Reset-Module.ps1"

$exportedNames=Get-Command -Module MarkDownPS | Select-Object -ExcludeProperty Name

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

    $guid="30e93b28-36d9-42fd-ace1-14b8eda0ded1"
    $hash=@{
        "Author"=$author;
        "Copyright"=$cop;
        "RootModule"=$psm1Name;
        "Description"=$description;
        "Guid"=$guid;
        "ModuleVersion"=$semVersion;
        "Path"=$psd1Path;
        "Tags"=@('Markdown', 'Tools');
        "LicenseUri"='https://github.com/Sarafian/RyanAirPS/blob/master/LICENSE';
        #"ProjectUri"= 'http://sarafian.github.io/RyanAirPS/';
        "IconUri" ='https://github.com/Sarafian/RyanAirPS/blob/master/RyanAir.jpg';
        "ReleaseNotes"= 'https://github.com/Sarafian/MarkdownPS/blob/master/CHANGELOG.md';
        "CmdletsToExport" = $exportedNames;
        "FunctionsToExport" = $exportedNames;
        "PowerShellHostVersion"="4.0"
    }

    New-ModuleManifest  @hash 
}