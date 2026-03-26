function Redirect-AppData {
    param (
        [string]$RelativePath,
        [string]$PersistDir,
        [string]$WebViewName = $null
    )

    $appdata_base = "$env:APPDATA"
    $junction_path = Join-Path $appdata_base $RelativePath

    # 1. 确保持久化目录存在
    if (!(Test-Path "$PersistDir")) {
        New-Item -Path "$PersistDir" -ItemType Directory -Force | Out-Null
    }

    # 2. 清理目标路径（处理 Junction 或普通文件夹）
    if (Test-Path "$junction_path") {
        $dest = Get-Item "$junction_path"
        if ($dest.Attributes -match 'ReparsePoint') {
            $dest.Delete()
        } else {
            Remove-Item "$junction_path" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # 3. 确保父级目录存在
    $parent_dir = Split-Path "$junction_path"
    if (!(Test-Path "$parent_dir")) {
        New-Item -Path "$parent_dir" -ItemType Directory -Force | Out-Null
    }

    # 4. 建立联结
    New-Item -ItemType Junction -Path "$junction_path" -Value "$PersistDir" | Out-Null

    # 5. 清理 WebView2 (Local)
    if ($WebViewName) {
        $local_webview = Join-Path "$env:LOCALAPPDATA" $WebViewName
        if (Test-Path "$local_webview") {
            Remove-Item "$local_webview" -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}