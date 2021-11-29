# 
Documentation for varius scripts


## Functions / scripts 

|   Function  |  Description  |
| ------------- | ------------- |
| ConnectedMonitors.ps1  | Deploy this script with SCCM / Group Policy and create a report of connected monitors ( SerialNumber, Manufacturer,WeekOfManufacture etc)  |
| WinServicestoInfluxDB.ps1  | From a windows server that can reach other server, push status of windows services to influxDB |
| graphAPI_upload_to_sharepoint.ps1 | This upload file to SharePoint Online using graphAPI, this works 100% with HTTP and is cross platform on PS7 | 
| Block_O365_logins_when_AD_password_expires.ps1 | Get users in AD that have the "password never expires" checkbox unchecked, and then check if it has the password expired. If it is expired, block login on office365, if not, do nothing on-prem AD | 
| RadioAPI.ps1 | Get list of all currently played music in NORWAY from Bauer media group ( Radio ROCK / KISS / RADIO NORGE ++) used in Azure automation and logic apps |
| webkameraerinorge.ps1 | Download pictures from https://www.webkameraerinorge.com/| 
| Convert-ToLatinCharacters.ps1 | from diacritics characters to standard English characters. Diacritic characters are extended or accented characters to the modern latin basic alphabet i.e. A-Z. Scandinavian diacritics such as å,ä and ö should in normalized form become a, a and o. Spanish diacritics should such as ó, ñ and ç should be normalized to o, n and c, this function does that | 
| epoch.ps1 | function to convert Unix timestamp to "normal time. i.e: epoch -epochTime "1623175200000" -Ms gives DateTime      : 08/06/2021 18:00:00 | 





## TODO 

|   Function  |  Description  |
| ------------- | ------------- |
|  |   |
