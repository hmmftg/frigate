$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

$components = @("common","components-dialog","config-cameras","config-global","objects","views-exports","views-search","views-settings","views-system")

foreach ($comp in $components) {
    $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/?format=json"
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        $total = $resp.total
        $translated = $resp.translated
        $checks = $resp.failing_checks
        $fuzzy = $resp.fuzzy
        $untranslated = $total - $translated - $fuzzy
        $pct = $resp.translated_percent
        Write-Output ("{0}: translated={1}/{2} ({3}%) untranslated={4} fuzzy={5} checks={6}" -f $comp, $translated, $total, $pct, $untranslated, $fuzzy, $checks)
    } catch {
        Write-Output ("{0}: ERROR - {1}" -f $comp, $_.Exception.Message)
    }
}
