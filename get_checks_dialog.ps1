$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token" }

$queries = @(
    "check:angularjs-format",
    "check:case-mismatch",
    "check:commented",
    "check:credits",
    "check:c-sharp-format",
    "check:double-quotes",
    "check:email",
    "check:end-question",
    "check:exclamation",
    "check:format",
    "check:format-java",
    "check:format-java-messageformat",
    "check:format-python",
    "check:format-python-brace",
    "check:html-entity",
    "check:html-tags",
    "check:icu-message-format",
    "check:id-whitespace",
    "check:inconsistent",
    "check:java-brace",
    "check:java-format",
    "check:java-messageformat",
    "check:javascript-format",
    "check:json-format",
    "check:kde-brace",
    "check:kde-format",
    "check:label-pattern",
    "check:long",
    "check:markdown-links",
    "check:markdown-refs",
    "check:markdown-syntax",
    "check:max-length",
    "check:multi-spaces",
    "check:multipart",
    "check:plurals",
    "check:python-brace-format",
    "check:python-format",
    "check:qt-format",
    "check:qt-plural",
    "check:ruby-format",
    "check:same",
    "check:same-plurals",
    "check:screen-size",
    "check:translatable",
    "check:unchanged",
    "check:url",
    "check:urls",
    "check:vue-format",
    "check:xml-tags",
    "check:zero-width-space"
)

$comp = "components-dialog"
$found = $false
foreach ($q in $queries) {
    $url = "https://hosted.weblate.org/api/translations/frigate-nvr/$comp/fa/units/?format=json&q=$q&page_size=100"
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Get
        if ($resp.count -gt 0) {
            if (-not $found) { Write-Output "=== $comp ==="; $found = $true }
            Write-Output "  [$q] ($($resp.count)):"
            foreach ($u in $resp.results) {
                Write-Output "    id=$($u.id) src: $($u.source)"
                Write-Output "    tgt: $($u.target)"
            }
        }
    } catch {}
}
if (-not $found) { Write-Output "=== $comp === (no matching checks found across all types)" }
