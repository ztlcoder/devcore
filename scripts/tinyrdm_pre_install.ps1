$appdata_base = "$env:APPDATA"
$junction_path = Join-Path $appdata_base "TinyRDM"
$webview_path = Join-Path $appdata_base "Tiny RDM.exe"

# 1. 准备 persist 目录
if (!(Test-Path "$persist_dir")) {
    New-Item -Path "$persist_dir" -ItemType Directory -Force | Out-Null
}

# 2. 清理旧的残留（包括普通文件夹和 WebView2 缓存）
foreach ($path in @($junction_path, $webview_path)) {
    if (Test-Path $path) {
        Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue
    }
}

# 3. 重新建立数据联结
New-Item -ItemType Junction -Path "$junction_path" -Value "$persist_dir" | Out-Null