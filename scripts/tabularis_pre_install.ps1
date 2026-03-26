. "$bucketsdir\devcore\scripts\utils.ps1"

# 1. 重定向 Roaming 下的 debba\tabularis (包含 data 和 config)
Redirect-AppData -RelativePath "debba\tabularis" -PersistDir "$persist_dir\roaming_data"

# 2. 清理 Local 下的 WebView2 (由于缓存无意义，仅清理不建立 Junction)
$local_webview = Join-Path "$env:LOCALAPPDATA" "tabularis"
if (Test-Path $local_webview) { Remove-Item $local_webview -Recurse -Force }