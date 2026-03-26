# 1. 变量定义
$appdata_base = "$env:APPDATA"
$junction_path = Join-Path $appdata_base "TinyRDM"
$webview_path = Join-Path $appdata_base "Tiny RDM.exe"

# 1. 移除目录联结 (只删链接，不删 persist 里的数据)
if (Test-Path "$junction_path") {
    $item = Get-Item "$junction_path"
    if ($item.Attributes -match 'ReparsePoint') {
        $item.Delete()
    }
}

# 2. 清理 WebView2 缓存文件夹 (这些通常没有保留价值)
if (Test-Path "$webview_path") {
    Remove-Item "$webview_path" -Recurse -Force -ErrorAction SilentlyContinue
}