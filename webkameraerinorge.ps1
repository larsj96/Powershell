$cameras= Invoke-WebRequest -Uri "https://www.webkameraerinorge.com/camlist_navigate.php" -UseBasicParsing

$FirstURI = @()
$cameraurl = @()
$camera = @()
$Filename = @()
$timedate =@()
$FirstURItime = @()
$cameraurltime = @()

foreach ($camera in $cameras.links.href)
{

$FirstURItime = [Diagnostics.Stopwatch]::StartNew()
$timedate = $((Get-Date).ToString('yyyy-MM-dd HH-mm'))
#WebkameraInorge are just redirecting to correct camera
$FirstURI = Invoke-WebRequest -Uri "https://www.webkameraerinorge.com/$camera" -UseBasicParsing
$cameraurl = $FirstURI.Images | Where-Object src -like "*://*" | select -First 1 
#whacky way to fetch name without specical charathers
$Filename = "$($cameraurl.alt)" -replace '[\W]', ''

$FirstURItime.Stop()
Write-host "Invoke-WebRequest -Uri  https://www.webkameraerinorge.com/$camera took this long: $($FirstURItime.Elapsed.Milliseconds)" -ForegroundColor Green

if ($null -eq $cameraurl)
{
# "Cannot validate argument on parameter 'Uri'. The argument is null or empty."
continue
}

# SRC  is full URI for redirect picture - AlT is the descrption 
# $cameraurl | Select-Object src, alt
if(!(test-path "C:\bilder\$Filename"))
{
New-Item -ItemType Directory -Path "C:\bilder\$Filename" -ErrorAction SilentlyContinue
}

$cameraurltime = [Diagnostics.Stopwatch]::StartNew()
Invoke-WebRequest -Uri  $cameraurl.src -UseBasicParsing -OutFile "C:\Bilder\$Filename\$timedate $($Filename).jpg"
$cameraurltime.Stop()
Write-host "Downloading JPG from $($cameraurl.src) took this long: $($cameraurltime.Elapsed.Milliseconds)" -ForegroundColor Green

}
