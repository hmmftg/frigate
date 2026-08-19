$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Get source unit URLs for these translation units
$ids = @(152349483, 152349489, 152359693, 175758738)

foreach ($id in $ids) {
    $url = "https://hosted.weblate.org/api/units/$id/?format=json"
    $unit = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
    $sourceUrl = $unit.source_unit
    Write-Output "Translation unit $id -> source: $($unit.source) source_unit=$sourceUrl"
    
    # Set extra_flags on the source unit
    $sourceUnitId = $sourceUrl -replace '.*\/api\/units\/(\d+)\/.*', '$1'
    $srcUrl = "https://hosted.weblate.org/api/units/$sourceUnitId/?format=json"
    $body = '{"extra_flags": "ignore-same"}'
    try {
        $resp = Invoke-RestMethod -Uri $srcUrl -Headers $headers -Method Patch -Body $body
        Write-Output "  source unit ${sourceUnitId}: OK flags=$($resp.extra_flags)"
    } catch {
        $errDetail = $_.ErrorDetails.Message
        Write-Output "  source unit ${sourceUnitId}: ERROR - $errDetail"
    }
}
