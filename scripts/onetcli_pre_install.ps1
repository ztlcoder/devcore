# 1. 定义路径：$persist_dir 是 Scoop 提供的变量，指向你的 persist\onetcli
$targetPersist = "$persist_dir\one-hub"
$appDataHub = "$env:APPDATA\one-hub"

# 2. 确保 persist 物理目录存在
if (!(Test-Path $targetPersist)) {
    New-Item -ItemType Directory -Path $targetPersist -Force | Out-Null
}

# 3. 处理已存在的 AppData 目录（防止覆盖已有数据）
if (Test-Path $appDataHub) {
    $item = Get-Item $appDataHub
    # 如果不是软连接，则把里面的数据库移到 persist
    if ($item.LinkType -ne "Junction") {
        Move-Item -Path "$appDataHub\*" -Destination $targetPersist -Force -ErrorAction SilentlyContinue
        Remove-Item -Recurse -Force $appDataHub
    }
}

# 4. 创建软连接：将 AppData\one-hub 映射到 persist\one-hub
if (!(Test-Path $appDataHub)) {
    New-Item -ItemType Junction -Path $appDataHub -Value $targetPersist | Out-Null
}