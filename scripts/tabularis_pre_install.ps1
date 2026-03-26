. "$bucketsdir\devcore\scripts\utils.ps1"

# 1. 重定向 Roaming\debba\tabularis 到 persist\tabularis\debba_data
Redirect-AppData -RelativePath "debba\tabularis" -PersistDir "$persist_dir\tabularis\debba_data"

# 2. 重定向 Roaming\tabularis 到 persist\tabularis\app_data
# 同时清理 Local 下的 webview2 缓存
Redirect-AppData -RelativePath "tabularis" -PersistDir "$persist_dir\tabularis\app_data" -WebViewName "tabularis"