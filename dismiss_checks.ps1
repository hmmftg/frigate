$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Dismiss checks on proper nouns / brand names that shouldn't be translated
$dismissIds = @(
    @{id=152349483; comp="objects"; reason="FedEx is a brand name, not translated"},
    @{id=152349489; comp="objects"; reason="PostNord is a brand name, not translated"},
    @{id=152359693; comp="views-system"; reason="{{camName}} FFmpeg - FFmpeg is a proper noun"},
    @{id=175758738; comp="views-system"; reason="go2rtc is a software name, not translated"}
)

foreach ($item in $dismissIds) {
    $url = "https://hosted.weblate.org/api/units/$($item.id)/?format=json"
    # Add ignore flag
    $body = @{ extra_flags = "ignore-inconsistent,ignore-unchanged" } | ConvertTo-Json
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body
        Write-Output "$($item.comp) unit $($item.id): flags set - OK"
    } catch {
        # Try reading the error
        Write-Output "$($item.comp) unit $($item.id): ERROR - $($_.Exception.Message)"
    }
}
