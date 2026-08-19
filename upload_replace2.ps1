$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

# Upload using Invoke-WebRequest with -Form
$file = (Resolve-Path "web\public\locales\fa\config\cameras.json").Path
$url = "https://hosted.weblate.org/api/translations/frigate-nvr/config-cameras/fa/file/"

$form = @{
    file = Get-Item $file
    method = "replace"
}

try {
    $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -Form $form
    Write-Output "config-cameras: accepted=$($resp.accepted) total=$($resp.total) not_found=$($resp.not_found)"
} catch {
    $errDetail = $_.ErrorDetails.Message
    Write-Output "config-cameras: ERROR - $errDetail"
}
