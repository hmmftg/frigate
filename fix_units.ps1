$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Fix config-cameras units
$camerasFixes = @(
    @{id=181427829; target="تعداد روزهایی که ضبط‌های رویدادهای تشخیص باید نگهداری شوند."},
    @{id=181427928; target="کیفیت عکس فوری"},
    @{id=181427929; target="کیفیت کدگذاری برای عکس‌های فوری ذخیره‌شده (0-100)."},
    @{id=181427976; target="ONVIF"},
    @{id=181428005; target="پس از از دست دادن ردیابی، این تعداد ثانیه صبر کنید قبل از بازگرداندن دوربین به موقعیت از پیش تعیین‌شده."}
)

foreach ($fix in $camerasFixes) {
    $url = "https://hosted.weblate.org/api/units/$($fix.id)/?format=json"
    $body = @{ target = $fix.target; state = 20 } | ConvertTo-Json
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body
        Write-Output "config-cameras unit $($fix.id): OK -> $($fix.target.Substring(0, [Math]::Min(40, $fix.target.Length)))..."
    } catch {
        Write-Output "config-cameras unit $($fix.id): ERROR - $($_.Exception.Message)"
    }
}

# Fix views-classificationmodel plural units
$classFixes = @(
    @{id=169239159; target=@("{{count}} کلاس حذف شد", "{{count}} کلاس حذف شدند")},
    @{id=169239160; target=@("{{count}} تصویر حذف شد", "{{count}} تصویر حذف شدند")}
)

foreach ($fix in $classFixes) {
    $url = "https://hosted.weblate.org/api/units/$($fix.id)/?format=json"
    $body = @{ target = $fix.target; state = 20 } | ConvertTo-Json -Depth 5
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body
        Write-Output "classification unit $($fix.id): OK"
    } catch {
        Write-Output "classification unit $($fix.id): ERROR - $($_.Exception.Message)"
    }
}

# Fix views-motionsearch plural units
$motionFixes = @(
    @{id=188252167; target=@("{{count}} تغییر حرکت یافت شد", "{{count}} تغییر حرکت یافت شدند")},
    @{id=188252175; target=@("{{count}} نقطه", "{{count}} نقطه‌ها")}
)

foreach ($fix in $motionFixes) {
    $url = "https://hosted.weblate.org/api/units/$($fix.id)/?format=json"
    $body = @{ target = $fix.target; state = 20 } | ConvertTo-Json -Depth 5
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body
        Write-Output "motionsearch unit $($fix.id): OK"
    } catch {
        Write-Output "motionsearch unit $($fix.id): ERROR - $($_.Exception.Message)"
    }
}
