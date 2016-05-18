function Get-RyanAirAvailability{
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
        [int] $FlexDaysIn,
        [Parameter(Mandatory=$false)]
        [switch] $RoundTrip,
        [Parameter(Mandatory=$false)]
        [int] $Adults=1,
        [Parameter(Mandatory=$false)]
        [int] $Teen=0,
        [Parameter(Mandatory=$false)]
        [int] $Children=0,
        [Parameter(Mandatory=$false)]
        [int] $Infants=0
    )
    $ryanAirApi="https://desktopapps.ryanair.com/en-gb/availability"
    Write-Debug $ryanAirApi
    $queryParameters=@{
        "Origin"=$Origin;
        "Destination"=$Destination;
        "DateOut"=$DateOut.ToString("yyyy-MM-dd");
        "DateIn"=$DateIn.ToString("yyyy-MM-dd");
        "FlexDaysOut"=$FlexDaysOut;
        "FlexDaysIn"=$FlexDaysIn;
        "RoundTrip"=$RoundTrip;
        "ADT"=$Adults;
        "TEEN"=$Teen;
        "CHD"=$Children;
        "INF"=$Infants;
        }
    Write-Debug $queryParameters
    $json=Invoke-RestMethod -Uri "$ryanAirApi" -Body $queryParameters -Method Get
    Write-Debug $json
    $availabilityHash=@{}
    $availabilityHash["Currency"]=$json.currency
    $availabilityHash["CurrPrecision"]=$json.currPrecision
    $availabilityHash["Trips"]=@()
    $availabilityHash["ServerTimeUTC"]=Get-Date $json.serverTimeUTC
    foreach($tripJson in $json.trips)
    {
        $tripHash=@{}
        $tripHash["Origin"]=$tripJson.origin
        $tripHash["Destination"]=$tripJson.destination
        $tripHash["Dates"]=@()
        foreach($dateJson in $tripJson.dates)
        {
            $dateHash=@{}
            $dateHash["DateOut"]=$dateJson.dateOut

            $dateHash["Flights"]=@()
            foreach($flightJson in $dateJson.flights)
            {
                $flightHash=@{}
                $flightHash["FlightNumber"]=$flightJson.flightNumber
                $flightHash["From"]=Get-Date $flightJson.time[0]
                $flightHash["To"]=Get-Date $flightJson.time[1]
                $flightHash["FromUTC"]=Get-Date $flightJson.timeUTC[0]
                $flightHash["ToUTC"]=Get-Date $flightJson.timeUTC[1]
                $flightHash["Duration"]=$flightJson.duration
                $flightHash["FaresLeft"]=$flightJson.faresLeft
                $flightHash["InfantsLeft"]=$flightJson.infantsLeft

                $regularFareHash=@{}
                $regularFareHash["FareKey"]=$flightJson.regularFare.fareKey
                $regularFareHash["FareClass"]=$flightJson.regularFare.fareClass
                $regularFareHash["Fares"]=@()
                foreach($fareJson in $flightJson.regularFare.fares)
                {
                    $fareHash=@{}
                    $fareHash["Type"]=$fareJson.type
                    $fareHash["Amount"]=[float]$fareJson.amount
                    $fareHash["Count"]=[int]$fareJson.count
                    $fareHash["HasDiscount"]=[boolean]$fareJson.hasDiscount
                    $fareHash["PublishedFare"]=[float]$fareJson.publishedFare
                    $regularFareHash["Fares"]+=New-Object PSObject –Prop $fareHash
                }
                $flightHash["RegularFare"]=New-Object PSObject –Prop $regularFareHash

                $businessFareHash=@{}
                $businessFareHash["FareKey"]=$flightJson.businessFare.fareKey
                $businessFareHash["FareClass"]=$flightJson.businessFare.fareClass
                $businessFareHash["Fares"]=@()
                foreach($fareJson in $flightJson.businessFare.fares)
                {
                    $fareHash=@{}
                    $fareHash["Type"]=$fareJson.type
                    $fareHash["Amount"]=[float]$fareJson.amount
                    $fareHash["Count"]=[int]$fareJson.count
                    $fareHash["HasDiscount"]=[boolean]$fareJson.hasDiscount
                    $fareHash["PublishedFare"]=[float]$fareJson.publishedFare
                    $businessFareHash["Fares"]+=New-Object PSObject –Prop $fareHash
                }
                $flightHash["BusinessFare"]=New-Object PSObject –Prop $businessFareHash

                $dateHash["Flights"]+=New-Object PSObject –Prop $flightHash
            }
            $tripHash["Dates"]+=New-Object PSObject –Prop $dateHash
        }
        $availabilityHash["Trips"]+=New-Object PSObject –Prop $tripHash
    }
    $availability=New-Object PSObject –Prop $availabilityHash
    return $availabilityHash

}