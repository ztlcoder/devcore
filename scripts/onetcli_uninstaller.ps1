$appDataHub = "$env:APPDATA\one-hub"

if (Test-Path $appDataHub) {
    $item = Get-Item $appDataHub
    # 仅删除软连接，不伤及 persist 里的原件
    if ($item.LinkType -eq "Junction") {
        Remove-Item $appDataHub -Force
    }
}