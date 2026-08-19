$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Fix config-cameras units (target must be an array)
$camerasFixes = @(
    @{id=181427829; target=@("تعداد روزهایی که ضبط‌های رویدادهای تشخیص باید نگهداری شوند.")},
    @{id=181427928; target=@("کیفیت عکس فوری")},
    @{id=181427929; target=@("کیفیت کدگذاری برای عکس‌های فوری ذخیره‌شده (0-100).")},
    @{id=181427976; target=@("ONVIF")},
    @{id=181428005; target=@("پس از از دست دادن ردیابی، این تعداد ثانیه صبر کنید قبل از بازگرداندن دوربین به موقعیت از پیش تعیین‌شده.")}
)

foreach ($fix in $camerasFixes) {
    $url = "https://hosted.weblate.org/api/units/$($fix.id)/?format=json"
    $body = @{ target = $fix.target; state = 20 } | ConvertTo-Json -Depth 5
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body
        Write-Output "config-cameras unit $($fix.id): OK"
    } catch {
        Write-Output "config-cameras unit $($fix.id): ERROR - $($_.Exception.Message)"
    }
}
