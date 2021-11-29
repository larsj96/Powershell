function epoch() { 
    Param( 
        [Parameter(ValueFromPipeline)]$epochTime,
        [Switch]$Ms
    ) 
    Process { 
        if ($Ms) {
            [System.DateTimeOffset]::FromUnixTimeMilliseconds($epochTime)
        } else {
            [System.DateTimeOffset]::FromUnixTimeSeconds($epochTime)
        }
    } 
}
