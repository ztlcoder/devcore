param([string]$AppName = "*")

$aria2 = (Get-Command "aria2c" -ErrorAction SilentlyContinue).Source
$tempDir = Join-Path $env:TEMP "scoop_hash_tmp_dir"
if (!(Test-Path $tempDir)) { New-Item $tempDir -ItemType Directory -Force | Out-Null }

Get-ChildItem "$PSScriptRoot\bucket\$AppName.json" | ForEach-Object {
    $file = $_.FullName
    $json = Get-Content $file -Raw | ConvertFrom-Json
    $url = $json.architecture.'64bit'.url
    $tempFile = Join-Path $tempDir "$($_.BaseName)_tmp"

    if ($url) {
        try {
            if ($aria2) {
                & $aria2 -q -x 5 -s 5 -d $tempDir -o "$($_.BaseName)_tmp" $url --allow-overwrite=true --console-log-level=error
            } else {
                Invoke-WebRequest -Uri $url -OutFile $tempFile -Quiet
            }

            if (Test-Path $tempFile) {
                $newHash = (Get-FileHash $tempFile -Algorithm SHA256).Hash.ToUpper()
                $json.architecture.'64bit'.hash = $newHash

                $jsonContent = ($json | ConvertTo-Json -Depth 20) -replace '(?m)^(\s+)', '$1$1'
                $jsonContent | Set-Content $file -Encoding UTF8

                Write-Host "Done: $($_.BaseName) -> $newHash" -ForegroundColor Green
            }
        } catch {
            Write-Host "Fail: $($_.BaseName)" -ForegroundColor Red
        } finally {
            if (Test-Path $tempFile) { Remove-Item $tempFile -ErrorAction SilentlyContinue }
        }
    }
}