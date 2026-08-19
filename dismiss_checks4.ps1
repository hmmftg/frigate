$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Units with proper nouns / brand names that should be dismissed
$dismissIds = @(
    # views-settings - proper nouns
    168462498,  # rtsp://...
    180934750,  # FFmpeg
    180934767,  # FFmpeg
    180934769,  # Logging
    180934865,  # go2rtc
    180934866,  # FFmpeg
    180934870,  # GenAI
    183614753,  # Intel QuickSync (H.264)
    183614754,  # Intel QuickSync (H.265)
    183614756,  # NVIDIA Jetson (H.264)
    183614757,  # NVIDIA Jetson (H.265)
    183614758,  # Rockchip RKMPP
    183739084,  # RTSP - Blue Iris
    190532331,  # VideoToolbox
    # config-global - proper nouns
    181578175,  # go2rtc
    181578310,  # DeepStack
    181578376,  # EdgeTPU
    181578405,  # Hailo-8/Hailo-8L
    181578434,  # MemryX
    181578492,  # OpenVINO
    181578604,  # TensorRT
    181579181,  # ONVIF (already fixed but may still have check)
    # config-cameras - proper nouns
    181427976,  # ONVIF (already fixed)
    # objects - proper nouns
    152349483,  # FedEx
    152349489,  # PostNord
    # views-system
    175758738,  # go2rtc
    152359693   # {{camName}} FFmpeg
)

foreach ($id in $dismissIds) {
    $url = "https://hosted.weblate.org/api/units/$id/?format=json"
    try {
        $unit = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        # Get source unit to set flags
        $sourceUrl = $unit.source_unit_url
        if ($sourceUrl) {
            $sourceUnit = Invoke-RestMethod -Uri "$($sourceUrl)?format=json" -Headers $headers -Method Get
            $existingFlags = $sourceUnit.extra_flags
            $newFlags = if ($existingFlags) { "$existingFlags,ignore-unchanged,ignore-inconsistent" } else { "ignore-unchanged,ignore-inconsistent" }
            $body = @{ extra_flags = $newFlags } | ConvertTo-Json
            Invoke-RestMethod -Uri "$($sourceUrl)?format=json" -Headers $headers -Method Patch -Body $body | Out-Null
            Write-Output "Dismissed: id=$id ctx=$($unit.context)"
        }
        Start-Sleep -Milliseconds 100
    } catch {
        Write-Output "FAIL: id=$id error=$($_.Exception.Message)"
    }
}
Write-Output "Done"
