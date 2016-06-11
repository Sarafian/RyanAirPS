# ![](RyanAir.jpg) RyanAirPS PowerShell module

Module is available on [PowerShell gallery](https://www.powershellgallery.com/packages/RyanAirPS/)

# Offered cmdlets

- `Get-RyanAirCommon` outputs metadata for airports, cities and countries served by RyanAir
- `Get-RyanAirSchedules` outputs the RyanAir's schedule for specific routes.
- `Get-RyanAirFlights` outputs single or round trip RyanAir flights for specific routes.

# Using the module

## Get-RyanAirCommon
```powershell
Get-RyanAirCommon -Type Countries
```

```powershell
Get-RyanAirCommon -Type Cities
```

```powershell
Get-RyanAirCommon -Type Cities
```

All airports are identified by their [IATA](http://www.iata.org/services/Pages/codes.aspx) code. Bind the airport to its city and then to its country through the `Code` property

## Get-RyanAirSchedules
Get RyanAir schedule from the Brussels (BRU) airport in Belgium
```powershell
Get-RyanAirSchedules -Origin BRU
```
Get RyanAir schedule from the Brussels (BRU) in Belgium to the Schönefeld (SXF) in Berlin Germany.

```powershell
Get-RyanAirSchedules -Origin BRU -Destination SXF
```

## Get-RyanAirFlights
Query all flights from `BRU` to `SXF`

```powershell
$date=Get-Date
Get-RyanAirFlights -Origin BRU -Destination SXF -DateOut $date
```

# Remarks

In general the module consumes the same REST api as the [RyanAir](https://www.ryanair.com/) web site does when browsing around their website.
