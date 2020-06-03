$data = Get-CimInstance -Namespace root\wmi -ClassName wmimonitorid -ComputerName $ComputerName | foreach {
	New-Object -TypeName psobject -Property @{
        Computername = ($env:COMPUTERNAME)
        Manufacturer = ($_.ManufacturerName -notmatch '^0$' | foreach {[char]$_}) -join ""
        Name = ($_.UserFriendlyName -notmatch '^0$' | foreach {[char]$_}) -join ""
        Serial = ($_.SerialNumberID -notmatch '^0$' | foreach {[char]$_}) -join ""
        WeekOfManufacture = ($_.WeekOfManufacture)
        YearOfManufacture = ($_.YearOfManufacture)
    }
}

$data

# VMs don't have CIMINSTANCE ->  monitors
if (!$data) { Write-Host "No data FROM CIMINSTANCE"; Write-Error "No data FROM CIMINSTANCE";
continue }


start-sleep -Seconds (1..120 | get-random)

try {
$data | Export-Csv -Path "\\fileshare\Temp\screens.csv" -NoTypeInformation -Append -ErrorAction Stop
}
catch 
{
$_
Write-Warning "Error exporting to fileshare, Error message: $_"
}
