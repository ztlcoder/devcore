$appdata_dir = "$env:APPDATA\TinyRDM"
# 仅删除软链接，不删除 persist 里的实际数据
if (Test-Path "$appdata_dir") {
    if ((Get-Item "$appdata_dir").Attributes -match 'ReparsePoint') {
        Remove-Item "$appdata_dir" -Force
    }
}