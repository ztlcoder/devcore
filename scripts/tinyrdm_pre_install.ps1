. "$bucketsdir\devcore\scripts\utils.ps1"

# 重定向 Roaming 里的 TinyRDM
Redirect-AppData -RelativePath "TinyRDM" -PersistDir "$persist_dir" -WebViewName "Tiny RDM.exe"