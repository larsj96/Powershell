$radios = Invoke-RestMethod -Uri "https://listenapi.planetradio.co.uk/api9.2/stations_nowplaying/NO" -ContentType "application/json; charset=UTF8"


foreach ($radio  in $radios) {


$object = [PSCustomObject]@{
    Artist     = $radio.stationNowPlaying.nowPlayingArtist
    Track = $radio.stationNowPlaying.nowPlayingTrack
    stationCode = $radio.stationCode
    stationOnAirTitle = $radio.stationOnAir.episodeTitle
    stationOnDescription = $radio.stationOnAir.episodeDescription

}

$object

}
