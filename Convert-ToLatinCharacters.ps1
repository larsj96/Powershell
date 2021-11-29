function Convert-ToLatinCharacters {
    param(
        [string]$inputString
    )
    [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($inputString))
}

<#
Convert-ToLatinCharacters  "Ægil Ørnes" -> gives this output : Agil Ornes

#>
