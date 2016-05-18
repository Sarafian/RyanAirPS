$names=(
    "Get-RyanAirAvailability"
    "Get-RyanAirCommon"
    "Get-RyanAirSchedulesPeriod"
    "Get-RyanAirSimpleRoundTrip"
)

$names | ForEach-Object {. $PSScriptRoot\$_.ps1 }

Export-ModuleMember $names


