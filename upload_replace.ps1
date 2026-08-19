$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

# Upload config-cameras.json with method=replace
$file = (Resolve-Path "web\public\locales\fa\config\cameras.json").Path
$url = "https://hosted.weblate.org/api/translations/frigate-nvr/config-cameras/fa/file/"

# Use multipart form with method=replace
$boundary = [System.Guid]::NewGuid().ToString()
$fileBytes = [System.IO.File]::ReadAllBytes($file)
$fileContent = [System.Text.Encoding]::UTF8.GetString($fileBytes)

$body = @"
--$boundary
Content-Disposition: form-data; name="method"

replace
--$boundary
Content-Disposition: form-data; name="file"; filename="cameras.json"
Content-Type: application/json

$fileContent
--$boundary--
"@

$headers2 = @{ Authorization = "Token $token"; "Content-Type" = "multipart/form-data; boundary=$boundary" }

try {
    $resp = Invoke-RestMethod -Uri $url -Headers $headers2 -Method Post -Body $body
    Write-Output "config-cameras: accepted=$($resp.accepted) total=$($resp.total) not_found=$($resp.not_found)"
} catch {
    $errDetail = $_.ErrorDetails.Message
    Write-Output "config-cameras: ERROR - $errDetail"
}
