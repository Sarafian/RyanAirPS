function Get-RyanAirSimpleRoundTrip{
    param(
        [Parameter(Mandatory=$true)]
        [string] $Origin,
        [Parameter(Mandatory=$true)]
        [string] $Destination,
        [Parameter(Mandatory=$true)]
        [DateTime] $DateOut,
        [Parameter(Mandatory=$true)]
        [DateTime] $DateIn,
        [Parameter(Mandatory=$true)]
        [int] $FlexDaysOut,
        [Parameter(Mandatory=$true)]
        [int] $FlexDaysIn
    )

    $availability=Get-RyanAirAvailability -Origin $Origin -Destination $Destination -DateOut $DateOut -DateIn $DateIn -FlexDaysOut $FlexDaysOut -FlexDaysIn $FlexDaysIn -RoundTrip
    $outboundDates=$availability.Trips | Where-Object {$_.Destination -eq $Destination}|Select-Object -ExpandProperty Dates |Where-Object {$_.Flights.Count -ge 1}
    $inboundDates=$availability.Trips | Where-Object {$_.Destination -eq $Origin}|Select-Object -ExpandProperty Dates |Where-Object {$_.Flights.Count -ge 1}
    $output=@{}
    $output.Outbound=@()
    $output.Inbound=@()

    foreach($date in $outboundDates)
    {
        foreach($flight in $date.Flights)
        {
            $flightHash=@{}
            $flightHash["Origin"]=$Origin
            $flightHash["Destination"]=$Destination
            $flightHash["Date"]=$flight.From.Date
            $flightHash["From"]=$flight.From
            $flightHash["To"]=$flight.To
            $flightHash["RegularFare"]=$flight.RegularFare.Fares[0].Amount
            $flightHash["BusinessFare"]=$flight.BusinessFare.Fares[0].Amount
            $flightHash["Currency"]=$availability.Currency
            $output.Outbound+=New-Object PSObject –Prop $flightHash
        }
    }

    foreach($date in $inboundDates)
    {
        foreach($flight in $date.Flights)
        {
            $flightHash=@{}
            $flightHash["Origin"]=$Destination
            $flightHash["Destination"]=$Origin
            $flightHash["Date"]=$flight.From.Date
            $flightHash["From"]=$flight.From
            $flightHash["To"]=$flight.To
            $flightHash["RegularFare"]=$flight.RegularFare.Fares[0].Amount
            $flightHash["BusinessFare"]=$flight.BusinessFare.Fares[0].Amount
            $flightHash["Currency"]=$availability.Currency
            $output.Inbound+=New-Object PSObject –Prop $flightHash
        }
    }
    
    return New-Object PSObject –Prop $output
}