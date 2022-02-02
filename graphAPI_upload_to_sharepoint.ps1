
# This code works on Powershell 7 on both  Windows / Ubuntu
# READ THIS LINK TO SETUP AZURE AD / GRAPH API
# https://www.pipehow.tech/invoke-graphapi/

# also read this if you want to upload big files: https://docs.microsoft.com/en-us/answers/questions/587655/graph-upload-large-file-with-powershell.html


#  in SPO site -> library settings > Versioning Settings. At the bottom is a toggle for Require Check Out (if you are struggle with  


$TenantId = "XXXXXXXX"

$Body = @{
    'tenant'        = $TenantId
    'client_id'     = "XXXXXXXXXXXX"
    'scope'         = 'https://graph.microsoft.com/.default'
    'client_secret' = "XXXXXXXXXXXXXX"
    'grant_type'    = 'client_credentials'
}

$Params = @{
  'Uri'         = "https://login.microsoftonline.com/$TenantId/oauth2/v2.0/token"
    'Method'      = 'Post'
    'Body'        = $Body
    'ContentType' = 'application/x-www-form-urlencoded'
}

$AuthResponse = Invoke-RestMethod @Params

$Headers = @{
    'Authorization' = "Bearer $($AuthResponse.access_token)"
}


$url = "https://graph.microsoft.com/v1.0/sites/TEENANTNAME.sharepoint.com:\sites\SITENAME:\drive"

$driveID = Invoke-RestMethod -Uri $url -Headers $Headers | Select-Object ID -ExpandProperty ID

$path = "/XXXXXX/XXXXX/XXXXXX.jpg" 

$url = "https://graph.microsoft.com/v1.0/drives/$driveID/items/root:/XXXXXXXX\XXXXX.jpg:/content" 

$upload = Invoke-RestMethod -Uri $url -Headers $headers -Method Put -InFile $path -ContentType 'text/plain' 

# Important note: if SPO site have check in and check out enabled, you need to run the code below (or turn it off as described in top of script) 

$itemID = $upload.id 
Invoke-RestMethod "https://graph.microsoft.com/v1.0/drives/$driveID/items/$itemID/checkin"-Headers $headers -Verbose -Method Put
