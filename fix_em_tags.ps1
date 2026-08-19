$token = "wlu_owUJ7qkCmcV9zYHrZOigvSvWyYVd10FROnGJ"
$headers = @{ Authorization = "Token $token"; "Content-Type" = "application/json" }

# Fix <em> tag spacing issues and other formatting problems
$fixes = @(
    @{id=152360530; target=@("ماسک‌های حرکت برای جلوگیری از این‌که انواع ناخواستهٔ حرکت باعث فعال‌شدن تشخیص شوند استفاده می‌شوند (مثلاً شاخه‌های درخت، مهر زمانیِ دوربین). ماسک‌های حرکت باید <em>با نهایت صرفه‌جویی</em> استفاده شوند؛ ماسک‌گذاریِ بیش‌ازحد باعث می‌شود ردیابی اشیا دشوارتر شود.")},
    @{id=152360562; target=@("بهبود کنتراست برای صحنه‌های تاریک‌تر. <em>پیش‌فرض: روشن</em>")},
    @{id=153411543; target=@("استفاده از <em>small</em> از نسخهٔ کوانتیزهٔ مدل استفاده می‌کند که RAM کم‌تری مصرف می‌کند و روی CPU سریع‌تر اجرا می‌شود، با تفاوت بسیار ناچیز در کیفیت جاسازی.")},
    @{id=153411545; target=@("استفاده از <em>large</em> از مدل کامل Jina استفاده می‌کند و در صورت امکان به‌طور خودکار روی GPU اجرا می‌شود.")},
    @{id=153411554; target=@("استفاده از <em>large</em> از مدل جاسازی چهرهٔ ArcFace استفاده می‌کند و در صورت امکان به‌طور خودکار روی GPU اجرا می‌شود.")},
    @{id=168462520; target=@("Frigate موارد بازبینی را به‌عنوان اعلان‌ها و تشخیص‌ها دسته‌بندی می‌کند. به‌طور پیش‌فرض، همهٔ اشیای <em>person</em> و <em>car</em> به‌عنوان اعلان در نظر گرفته می‌شوند. می‌توانید با پیکربندی نواحی لازم برای آن‌ها، طبقه‌بندی موارد بازبینی خود را دقیق‌تر کنید.")}
)

foreach ($fix in $fixes) {
    $body = @{ target = $fix.target; state = 20 } | ConvertTo-Json -Depth 5
    $url = "https://hosted.weblate.org/api/units/$($fix.id)/?format=json"
    try {
        Invoke-RestMethod -Uri $url -Headers $headers -Method Patch -Body $body | Out-Null
        Write-Output "OK: id=$($fix.id)"
        Start-Sleep -Milliseconds 100
    } catch {
        Write-Output "FAIL: id=$($fix.id) error=$($_.Exception.Message)"
    }
}
Write-Output "Done"
