function Get-RyanAirCommon{
    $ryanAirApi="https://api.ryanair.com/aggregate/3/common?embedded=airports,countries,cities&market=en-gb"
    $json=Invoke-RestMethod -Uri "$ryanAirApi" -Method Get
    $common=@{}
    $common["Countries"]=@()
    $common["Cities"]=@()
    $common["Airports"]=@()
    foreach($countryJson in $json.countries)
    {
        $countryHash=@{}
        $countryHash["Code"]=$countryJson.code
        $countryHash["Name"]=$countryJson.name
        $countryHash["Currency"]=$countryJson.currency
        $common["Countries"]+=New-Object PSObject –Prop $countryHash
    }
    foreach($cityJson in $json.cities)
    {
        $cityHash=@{}
        $cityHash["Code"]=$cityJson.code
        $cityHash["Name"]=$cityJson.name
        $cityHash["CountryCode"]=$cityJson.countryCode
        $common["Cities"]+=New-Object PSObject –Prop $cityHash
    }
    foreach($airportJson in $json.airports)
    {
        $airportHash=@{}
        $airportHash["IataCode"]=$airportJson.iataCode
        $airportHash["Name"]=$airportJson.name
        $airportHash["Base"]=[boolean]$airportJson.base
        $airportHash["CountryCode"]=$airportJson.countryCode
        $airportHash["CityCode"]=$airportJson.cityCode
        $common["Airports"]+=New-Object PSObject –Prop $airportHash
    }

    return New-Object PSObject –Prop $common
}