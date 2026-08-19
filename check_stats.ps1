$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

$components = @("common","components-dialog","config-cameras","config-global","objects","views-exports","views-search","views-settings","views-system")

foreach ($comp in $components) {
    $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/?format=json"
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        $total = $resp.total_units
        $translated = $resp.translated_units
        $checks = $resp.total_checks
        $untranslated = $total - $translated
        $pct = if ($total -gt 0) { [math]::Round($translated / $total * 100, 1) } else { 0 }
        Write-Output "${comp}: translated=${translated}/${total} (${pct}%) untranslated=${untranslated} checks=${checks}"
    } catch {
        Write-Output "${comp}: ERROR - $($_.Exception.Message)"
    }
}
