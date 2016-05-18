$names=@(
    "Get-RyanAirAvailability"
    "Get-RyanAirCommon"
    "Get-RyanAirSchedulesPeriod"
    "Get-RyanAirRoundTrip"
)

$names | ForEach-Object {. $PSScriptRoot\$_.ps1 }

Export-ModuleMember $names


