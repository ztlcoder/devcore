# 1. 变量定义
$appdata_base = "$env:APPDATA"
$junction_path = Join-Path $appdata_base "TinyRDM"
$webview_path = Join-Path $appdata_base "Tiny RDM.exe"

# 2. 移除目录联结（Junction）
if (Test-Path "$junction_path") {
    $item = Get-Item "$junction_path"
    if ($item.Attributes -match 'ReparsePoint') {
        $item.Delete()
    }
}

# 3. 彻底清理 WebView2 运行时产生的冗余文件夹
if (Test-Path "$webview_path") {
    Remove-Item "$webview_path" -Recurse -Force -ErrorAction SilentlyContinue
}