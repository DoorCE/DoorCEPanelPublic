$sourceDir = "lib\locales\sources"
$targetDir = "lib\locales"

# Step 1: Copy and rename .jsonc to .arb
Get-ChildItem -Path $sourceDir -Filter *.jsonc | ForEach-Object {
    $targetFile = Join-Path $targetDir ($_.BaseName + ".arb")
    Copy-Item $_.FullName $targetFile -Force
}

# Step 2: Remove all comments (full-line and inline) from the copied .arb files
Get-ChildItem -Path $targetDir -Filter *.arb | ForEach-Object {
    $lines = Get-Content $_.FullName
    $cleaned = $lines | ForEach-Object {
        # Remove full-line comments and inline comments
        $_ -replace '^\s*//.*$','' -replace '(?<!:)//.*$',''
    } | Where-Object { $_.Trim() -ne "" }
    Set-Content $_.FullName $cleaned
}

# Step 3: Run Flutter localization generation
flutter gen-l10n