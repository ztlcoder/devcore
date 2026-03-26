$appdata_base = "$env:APPDATA"
$local_base = "$env:LOCALAPPDATA"

# 需要解除链接的路径列表
$junctions = @(
    Join-Path $appdata_base "debba\tabularis",
    Join-Path $appdata_base "tabularis"
)

foreach ($j in $junctions) {
    if (Test-Path $j) {
        $item = Get-Item $j
        # 仅当它是 Junction 时才删除链接
        if ($item.Attributes -match 'ReparsePoint') {
            $item.Delete()
        }
    }
}

# 清理 Local 下的 WebView2 缓存文件夹（通常为应用名）
$webview = Join-Path $local_base "tabularis"
if (Test-Path $webview) {
    Remove-Item $webview -Recurse -Force -ErrorAction SilentlyContinue
}