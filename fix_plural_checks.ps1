$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Plural units: target must be array [one, other]
$fixes = @(
    @{id=180934921; target=@("{{count}} بخش با موفقیت ذخیره شد.", "همه {{count}} بخش با موفقیت ذخیره شد.")},
    @{id=180934922; target=@("{{successCount}} از {{totalCount}} بخش ذخیره شد. {{failCount}} ناموفق بود.", "{{successCount}} از {{totalCount}} بخش ذخیره شد. {{failCount}} ناموفق بود.")},
    @{id=188704145; target=@("{{count}} دوربین مقادیر این بخش را لغو می‌کند. برای دیدن جزئیات کلیک کنید.", "{{count}} دوربین مقادیر این بخش را لغو کرده‌اند. برای دیدن جزئیات کلیک کنید.")},
    @{id=188704146; target=@("این بخش سراسری فیلدهایی دارد که در {{count}} دوربین لغو شده است.", "این بخش سراسری فیلدهایی دارد که در {{count}} دوربین لغو شده است.")},
    @{id=188704147; target=@("{{count}} مورد دیگر", "{{count}} مورد دیگر")},
    @{id=188704155; target=@("در {{count}} دوربین لغو شده", "در {{count}} دوربین لغو شده")},
    @{id=190164705; target=@("این دوربین {{count}} فیلد از پیکربندی سراسری را لغو می‌کند:", "این دوربین {{count}} فیلد از پیکربندی سراسری را لغو می‌کند:")},
    @{id=190164707; target=@("پروفایل {{profile}} تعداد {{count}} فیلد از پیکربندی پایه را لغو می‌کند:", "پروفایل {{profile}} تعداد {{count}} فیلد از پیکربندی پایه را لغو می‌کند:")},
    @{id=190504762; target=@("{{count}} بخش با موفقیت ذخیره شد. فریگیت را بازراه‌اندازی کنید تا تغییرات اعمال شود.", "همه {{count}} بخش با موفقیت ذخیره شد. فریگیت را بازراه‌اندازی کنید تا تغییرات اعمال شود.")},
    @{id=182897058; target=@("{{count}} دوربین", "{{count}} دوربین")},
    @{id=191711016; target=@("{{count}} تغییر اعمال خواهد شد", "{{count}} تغییر اعمال خواهد شد")},
    @{id=191711023; target=@("تنظیمات به {{count}} دوربین کپی شد", "تنظیمات به {{count}} دوربین کپی شد")},
    @{id=191711024; target=@("تنظیمات به {{count}} دوربین کپی شد. فریگیت را بازراه‌اندازی کنید تا همه تغییرات اعمال شود.", "تنظیمات به {{count}} دوربین کپی شد. فریگیت را بازراه‌اندازی کنید تا همه تغییرات اعمال شود.")},
    # Non-plural fixes
    @{id=152360691; target=@("برخی دوربین‌ها عکس فوری غیرفعال دارند")},
    @{id=181579181; target=@("ONVIF")},
    @{id=181427976; target=@("ONVIF")}
)

$updated = 0
$failed = 0

foreach ($fix in $fixes) {
    $body = @{ target = $fix.target; state = 20 } | ConvertTo-Json -Depth 5
    $url = "https://hosted.weblate.org/api/units/$($fix.id)/?format=json"
    try {
        $resp = Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body
        $updated++
        Write-Output "OK: id=$($fix.id) target=$($resp.target)"
        Start-Sleep -Milliseconds 100
    } catch {
        $failed++
        Write-Output "FAIL: id=$($fix.id) error=$($_.Exception.Message)"
    }
}

Write-Output "Done: updated=$updated failed=$failed"
