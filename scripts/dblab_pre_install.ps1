. "$bucketsdir\devcore\scripts\utils.ps1"

# 将 Roaming\dblab 重定向到 persist\dblab\config
Redirect-AppData -RelativePath "dblab" -PersistDir "$persist_dir\dblab"