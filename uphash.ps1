param([string]$AppName = "*")

$aria2 = (Get-Command "aria2c" -ErrorAction SilentlyContinue).Source
$tempDir = Join-Path $env:TEMP "scoop_hash_tmp_dir"
if (!(Test-Path $tempDir)) { New-Item $tempDir -ItemType Directory -Force | Out-Null }

Get-ChildItem "$PSScriptRoot\bucket\$AppName.json" | ForEach-Object {
    $file = $_.FullName
    $json = Get-Content $file -Raw | ConvertFrom-Json
    $baseName = $_.BaseName
    $updated = $false

    # 逻辑 1：处理带有 architecture 的多架构软件 (如 PHP, Go, Node)
    if ($json.architecture) {
        $json.architecture.PSObject.Properties | ForEach-Object {
            $arch = $_.Name # 可能是 64bit, 32bit, arm64 等
            $url = $json.architecture.$arch.url
            if ($url) {
                $tempFile = Join-Path $tempDir "$($baseName)_$($arch)_tmp"
                Write-Host "Updating $baseName ($arch)..." -ForegroundColor Cyan
                if ($aria2) { & $aria2 -q -x 5 -s 5 -d $tempDir -o "$($baseName)_$($arch)_tmp" $url --allow-overwrite=true }
                else { Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing }

                if (Test-Path $tempFile) {
                    $json.architecture.$arch.hash = (Get-FileHash $tempFile -Algorithm SHA256).Hash.ToLower()
                    Remove-Item $tempFile -Force
                    $updated = $true
                }
            }
        }
    }
    # 逻辑 2：处理不分架构的简单软件
    elseif ($json.url) {
        $tempFile = Join-Path $tempDir "$($baseName)_tmp"
        Write-Host "Updating $baseName (Single Arch)..." -ForegroundColor Cyan
        if ($aria2) { & $aria2 -q -x 5 -s 5 -d $tempDir -o "$($baseName)_tmp" $json.url --allow-overwrite=true }
        else { Invoke-WebRequest -Uri $json.url -OutFile $tempFile -UseBasicParsing }

        if (Test-Path $tempFile) {
            $json.hash = (Get-FileHash $tempFile -Algorithm SHA256).Hash.ToLower()
            Remove-Item $tempFile -Force
            $updated = $true
        }
    }

    # 保存文件
    if ($updated) {
        $jsonContent = ConvertTo-Json $json -Depth 20
        $jsonContent = $jsonContent.Replace("`r`n", "`n")
        Set-Content $file $jsonContent -Encoding UTF8
        Write-Host "Success: $baseName updated." -ForegroundColor Green
    }
}