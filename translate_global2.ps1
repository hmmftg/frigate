# Translation map for remaining 31 untranslated values
$translations = @{
    "Maximum attribute area" = "حداکثر مساحت ویژگی"
    "Minimum aspect ratio" = "حداقل نسبت ابعاد"
    "Filters applied to detected attributes to reduce false positives (area, ratio, confidence)." = "فیلترهای اعمال‌شده روی ویژگی‌های تشخیص‌داده‌شده برای کاهش مثبت‌های کاذب (مساحت، نسبت، اطمینان)."
    "Minimum single-frame detection confidence required to associate this attribute with its parent object." = "حداقل اطمینان تشخیص تک‌فریمی مورد نیاز برای مرتبط کردن این ویژگی با شیء والد آن."
    "Minimum width/height ratio required for the bounding box to qualify." = "حداقل نسبت عرض/ارتفاع مورد نیاز برای واجد شرایط بودن کادر مرزی."
    "Maximum width/height ratio allowed for the bounding box to qualify." = "حداکثر نسبت عرض/ارتفاع مجاز برای واجد شرایط بودن کادر مرزی."
    "Polygon coordinates defining where this filter applies within the frame." = "مختصات چندضلعی که مشخص می‌کند این فیلتر در کجای فریم اعمال می‌شود."
    "Raw Mask" = "ماسک خام"
    "Minimum attribute area" = "حداقل مساحت ویژگی"
    "Attribute filters" = "فیلترهای ویژگی"
    "Maximum bounding box area (pixels or percentage) allowed for this attribute. Can be pixels (int) or percentage (float between 0.000001 and 0.99)." = "حداکثر مساحت کادر مرزی (پیکسل یا درصد) مجاز برای این ویژگی. می‌تواند پیکسل (عدد صحیح) یا درصد (اعداد شناور بین 0.000001 و 0.99) باشد."
    "Minimum bounding box area (pixels or percentage) required for this attribute. Can be pixels (int) or percentage (float between 0.000001 and 0.99)." = "حداقل مساحت کادر مرزی (پیکسل یا درصد) مورد نیاز برای این ویژگی. می‌تواند پیکسل (عدد صحیح) یا درصد (اعداد شناور بین 0.000001 و 0.99) باشد."
    "Average detection confidence threshold required for the attribute to be considered a true positive." = "آستانه اطمینان تشخیص میانگین مورد نیاز تا ویژگی به‌عنوان مثبت واقعی در نظر گرفته شود."
    "Confidence threshold" = "آستانه اطمینان"
    "Minimum confidence" = "حداقل اطمینان"
    "Settings for audio-based event detection for all cameras; can be overridden per-camera." = "تنظیمات تشخیص رویداد مبتنی بر صدا برای همه دوربین‌ها؛ قابل لغو به ازای هر دوربین."
    "Filter mask" = "ماسک فیلتر"
    "Maximum aspect ratio" = "حداکثر نسبت ابعاد"
}

# Read the file
$filePath = (Resolve-Path "web\public\locales\fa\config\global.json").Path
$content = [System.IO.File]::ReadAllText($filePath, [System.Text.UTF8Encoding]::new($false))

$replaced = 0
foreach ($en in $translations.Keys) {
    $fa = $translations[$en]
    if ($content.Contains($en)) {
        $content = $content.Replace($en, $fa)
        $replaced++
    }
}

[System.IO.File]::WriteAllText($filePath, $content, [System.Text.UTF8Encoding]::new($false))
Write-Output "Replaced $replaced values"
