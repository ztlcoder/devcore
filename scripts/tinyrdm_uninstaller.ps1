$appdata_base = "$env:APPDATA"
$local_base = "$env:LOCALAPPDATA"

# 1. 移除 Roaming 下的 Junction
$junction = Join-Path $appdata_base "TinyRDM"
if (Test-Path $junction) {
    $item = Get-Item $junction
    if ($item.Attributes -match 'ReparsePoint') { $item.Delete() }
}

# 2. 彻底清理 WebView2 缓存 (Tiny RDM.exe 文件夹)
$webview = Join-Path $appdata_base "Tiny RDM.exe"
if (Test-Path $webview) {
    Remove-Item $webview -Recurse -Force -ErrorAction SilentlyContinue
}