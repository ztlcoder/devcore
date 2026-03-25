$appdata_dir = "$env:APPDATA\TinyRDM"
# 确保 Scoop 的 persist 目录存在
if (!(Test-Path "$persist_dir")) {
    New-Item -Path "$persist_dir" -ItemType Directory -Force | Out-Null
}

# 强行清理旧路径，为建立 Junction 腾位置
if (Test-Path "$appdata_dir") {
    Remove-Item "$appdata_dir" -Recurse -Force -ErrorAction SilentlyContinue
}

# 建立“传送门”：AppData\TinyRDM -> Scoop\Persist
New-Item -ItemType Junction -Path "$appdata_dir" -Value "$persist_dir" | Out-Null