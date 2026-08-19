$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Test with a single unit first
$testUrl = "https://hosted.weblate.org/api/units/181578683/?format=json"
$unit = Invoke-RestMethod -Uri $testUrl -Headers $headers -Method Get
Write-Output "source type: $($unit.source.GetType().Name) value: $($unit.source)"
Write-Output "target type: $($unit.target.GetType().Name) value: $($unit.target)"
Write-Output "context: $($unit.context)"

# Try patching with array target
$persianVal = "قالب رنگ پیکسل مورد انتظار مدل: 'rgb'، 'bgr' یا 'yuv'."
$body = @{ target = @($persianVal); state = 20 } | ConvertTo-Json -Depth 5
Write-Output "body: $body"

try {
    $resp = Invoke-RestMethod -Uri $testUrl -Headers $headers -Method Patch -Body $body
    Write-Output "SUCCESS: target=$($resp.target)"
} catch {
    $errDetail = $_.ErrorDetails.Message
    Write-Output "ERROR: $errDetail"
}
