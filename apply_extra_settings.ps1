$extra = @{
    "Profile '{{profile}}' created" = "پروفایل «{{profile}}» ایجاد شد"
    "{{count}} labels selected" = "{{count}} برچسب انتخاب شد"
    "Active Objects" = "اشیاء فعال"
    "Motion Mask {{number}}" = "ماسک حرکت {{number}}"
    "Stream URLs and roles" = "آدرس‌ها و نقش‌های جریان"
}

$en = Get-Content "web\public\locales\en\views\settings.json" -Raw | ConvertFrom-Json -Depth 30
$fa = Get-Content "web\public\locales\fa\views\settings.json" -Raw | ConvertFrom-Json -Depth 30

function Apply-Extra($enObj, $faObj) {
    foreach ($key in $enObj.PSObject.Properties.Name) {
        if ($faObj.PSObject.Properties.Name -contains $key) {
            $enVal = $enObj.$key
            $faVal = $faObj.$key
            if ($enVal -is [System.Management.Automation.PSCustomObject] -and $faVal -is [System.Management.Automation.PSCustomObject]) {
                Apply-Extra $enVal $faVal
            } elseif ($enVal -is [string] -and $faVal -is [string] -and $enVal -eq $faVal) {
                if ($extra.ContainsKey($enVal)) {
                    $faObj.$key = $extra[$enVal]
                }
            }
        }
    }
}

Apply-Extra $en $fa

$json = $fa | ConvertTo-Json -Depth 30
[System.IO.File]::WriteAllText((Resolve-Path "web\public\locales\fa\views\settings.json").Path, $json, [System.Text.UTF8Encoding]::new($false))
Write-Output "Done"
