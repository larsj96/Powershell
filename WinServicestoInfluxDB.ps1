<#
.SYNOPSIS
    Service monitoring script to influxDB

.NOTES

    Version: 1.0
    Author: Lars Jørgen 
    Creation Date: 23.10.2020


*The user running this scripts need access to servers remotely
* this scripts require PowerShell-Influx from https://github.com/markwragg/PowerShell-Influx

https://sid-500.com/2018/02/24/powershell-encrypt-and-store-your-passwords-and-use-them-for-remote-authentication-protect-cmsmessage/

#>



#region securing telegraf password ( One time use)
<#

$Cert  = New-SelfSignedCertificate -DnsName InfluxDBPassword -CertStoreLocation "Cert:\CurrentUser\My" -KeyUsage KeyEncipherment,DataEncipherment,KeyAgreement -Type DocumentEncryptionCert

Export-PfxCertificate -Cert "Cert:\CurrentUser\My\$($Cert.Thumbprint)" -FilePath C:\scripts\influxdbpassord.pfx -Password (ConvertTo-SecureString -AsPlainText 'XXXXXXXXXXXX' -Force)

'Influxpassword' | Protect-CmsMessage -To $cert.subject -OutFile C:\scripts\influxdbpassord.txt

#>
#endregion

#region Register a scheduled task
<#

# https://stackoverflow.com/questions/20108886/scheduled-task-with-daily-trigger-and-repetition-interval
$Trigger= New-ScheduledTaskTrigger -At (Get-Date) -once  -RepetitionInterval (New-TimeSpan -Minutes 5)
$User= whoami
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "C:\scripts\WinServicestoInfluxDB.ps1" 
Register-ScheduledTask -TaskName "WinServiceInfluxDB" -Trigger $Trigger -User $User -Action $Action -RunLevel Highest –Force

#>
#endregion


$password = Unprotect-CmsMessage -Path C:\Scripts\influxdbpassord.txt
$securepasswd = ConvertTo-SecureString "$password" -AsPlainText -Force
#telegraf is the username in my InfluxDB
$credential = New-Object System.Management.Automation.PSCredential ("telegraf", $securepasswd)

$monitors = @(
    @{
        ComputerName = 'DC01'
        Monitor      = 'WindowsService'
        servicename  = @{
            Name = 'cryptsvc', 'bits'
        }
    }

    @{
        ComputerName = 'NotAServer'
        Monitor      = 'WindowsService'
        servicename  = @{
            Name = 'cryptsvc', 'bits'
        }
    }

    @{
        ComputerName = 'DC02'
        Monitor      = 'WindowsService'
        servicename  = @{
            Name = 'cryptsvc', 'bits'
        }
    }

    @{
        ComputerName = 'WINBAST01'
        Monitor      = 'WindowsService'
        servicename  = @{
            Name = 'cryptsvc', 'bits'
        }
    }
)

$now = Get-Date
# Adding 5 minutes as this will run in a scheduled task

while ($now.AddMinutes(-5) -lt (Get-Date)) {


    $Winservices = @()
    $computername = @()
    $Winservices = @()



    $monitors | Where-Object Monitor -Match "WindowsService" | ForEach-Object {

        if ((Test-Connection -ComputerName $_.ComputerName -BufferSize 16 -Count 1 -ErrorAction 0 -quiet)) {
 
            try {
                $Winservices = (Get-Service $_.servicename.Name -ComputerName $_.ComputerName | Select-Object Status, Name, DisplayName)
                Write-Verbose "Fetching services from $($_.ComputerName) "
            }

            catch {
                $_
                Write-Error "Failed to fetch services from $($_.ComputerName) "
            }

            $computername = $_.ComputerName

            $Winservices | ForEach-Object {

                $service = [PSCustomObject]@{
                    Status       = $_.status.tostring()
                    Name         = $_.Name.tostring()
                    DisplayName  = $_.DisplayName.tostring()
                    ComputerName = $computername
                }
                $service | ConvertTo-Metric -Measure WindowsService -MetricProperty status -TagProperty Status, Name -Tags @{ComputerName = $computername }  | Write-Influx -Database telegraf -Server http://10.103.0.101:8086 -Credential $credential -Verbose
                Start-Sleep 1
            }

            write-host (get-date ) -ForegroundColor Green
            Start-Sleep 3
        }

    }
}
