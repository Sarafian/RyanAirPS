function Get-RyanAirSchedulesPeriod{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Origin,
        [Parameter(Mandatory=$false)]
        [string] $Destination=$null
    )
    if($Destination)
    {
        $ryanAirApi="https://api.ryanair.com/timetable/3/schedules/$Origin/$Destination/period"
    }
    else
    {
        $ryanAirApi="https://api.ryanair.com/timetable/3/schedules/$origin/periods"
    }
    Write-Debug $ryanAirApi
    $json=Invoke-RestMethod -Uri "$ryanAirApi" -Method Get 
    Write-Debug $json
    $schedules=@()
    $hash=@{}
    if($Destination)
    {
        $hash["Origin"]=$Origin
        $hash["Destination"]=$Destination
        $hash["Months"]=$json.months
        $hash["MonthsFromToday"]=$json.monthsFromToday
        $hash["FirstFlightDate"]=Get-Date $json.firstFlightDate
        $hash["LastFlightDate"]=Get-Date $json.lastFlightDate
        $schedule=New-Object PSObject –Prop $hash
        return $schedule
    }
    else
    {
        $destinations=@()
        $json|Get-Member |Where-Object {$_.MemberType -eq "NoteProperty"} |ForEach-Object {
            $scheduleJson=$json| Select -ExpandProperty $_.Name
            $hash["Origin"]=$Origin
            $hash["Destination"]=$_.Name
            $hash["Months"]=$scheduleJson.months
            $hash["MonthsFromToday"]=$scheduleJson.monthsFromToday
            $hash["FirstFlightDate"]=Get-Date $scheduleJson.firstFlightDate
            $hash["LastFlightDate"]=Get-Date $scheduleJson.lastFlightDate
            $schedule=New-Object PSObject –Prop $hash
            $schedules+=$schedule
        }
        return $schedules
    }
}