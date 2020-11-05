$adusers = Get-ADUser -filter { Enabled -eq $True -and PasswordNeverExpires -eq $false } –Properties "CannotChangePassword", "samaccountname", "userprincipalname", "DisplayName", "msDS-UserPasswordExpiryTimeComputed" |
Select-Object -Property  "samaccountname", "userprincipalname", "Displayname", @{Name = "ExpiryDate"; Expression = { [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") } }


Import-Module Msonline
#Connect PowerShell to Azure AD
$UserCredential = Get-Credential
Connect-MsolService -Credential $UserCredential


foreach ($user in $adusers) {

if($user.CannotChangePassword -eq $true -and [datetime]::FromFileTime($user."msDS-UserPasswordExpiryTimeComputed") -lt (Get-Date)){
    #https://docs.microsoft.com/en-us/microsoft-365/enterprise/block-user-accounts-with-microsoft-365-powershell?view=o365-worldwide
    Set-ADUser -Identity $user.samaccountname -PasswordNeverExpires $false
    Set-Msoluser -UserPrincipalName $user.UserPrincipalName -BlockCredential $true
    Write-Host "$($user.UserPrincipalName) blocking access to office 365"
}
