$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

$queries = @(
    "check:unchanged",
    "check:inconsistent", 
    "check:double_space",
    "check:xml-tags",
    "check:bbcode",
    "check:escaped-newline",
    "check:starting-space",
    "check:trailing-space",
    "check:endpunctuation",
    "check:begin-space",
    "check:end-space",
    "check:markdown-links",
    "check:placeholder",
    "check:plurals",
    "check:same-plurals",
    "check:ellipsis"
)

$components = @("common","components-dialog","config-cameras","objects","views-classificationmodel","views-exports","views-motionsearch","views-search","views-system")

foreach ($comp in $components) {
    $found = $false
    foreach ($q in $queries) {
        $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/units/?format=json&q=$q&page_size=100"
        try {
            $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
            if ($resp.count -gt 0) {
                if (-not $found) { Write-Output "=== $comp ==="; $found = $true }
                Write-Output "  [$q] ($($resp.count)):"
                foreach ($u in $resp.results) {
                    Write-Output "    src: $($u.source)"
                    Write-Output "    tgt: $($u.target)"
                }
            }
        } catch {}
    }
    if (-not $found) { Write-Output "=== $comp === (no matching checks found)" }
}
