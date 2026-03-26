# 遍历所有 json 文件
Get-ChildItem "$PSScriptRoot\bucket\*.json" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw | ConvertFrom-Json
    $url = $content.architecture.'64bit'.url

    if ($url) {
        Write-Host "正在处理: $($_.Name)" -ForegroundColor Cyan
        $temp = Join-Path $env:TEMP "scoop_hash_tmp"

        # 使用系统 WebClient 下载
        $wc = New-Object System.Net.WebClient
        try {
            $wc.DownloadFile($url, $temp)
            $newHash = (Get-FileHash $temp -Algorithm SHA256).Hash.ToUpper()

            # 更新对象并写回文件
            $content.architecture.'64bit'.hash = $newHash
            $content | ConvertTo-Json -Depth 20 | Set-Content $_.FullName -Encoding UTF8
            Write-Host "成功更新 Hash: $newHash" -ForegroundColor Green
        } catch {
            Write-Host "下载失败: $($_.Name)" -ForegroundColor Red
        } finally {
            if (Test-Path $temp) { Remove-Item $temp }
        }
    }
}