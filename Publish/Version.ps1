function Get-Version {
    $major=1
    $minor=0
    $patch=0

    return "$major.$minor"    

    $date=(Get-Date).ToUniversalTime()

    $build=[string](1200 * ($date.Year -2015)+$date.Month*100+$date.Day)+$date.ToString("HHmmss")
    "$major.$minor.$build.$patch"    
}