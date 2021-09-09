$radios = Invoke-RestMethod -Uri "https://listenapi.planetradio.co.uk/api9.2/stations_nowplaying/NO"

# 
foreach ($radio in $radios)

{

$radio
break


}
