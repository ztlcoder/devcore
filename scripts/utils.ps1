function Redirect-AppData {
    param (
        [string]$RelativePath, # 例如 "debba\tabularis"
        [string]$PersistDir,
        [string]$WebViewName = $null,
        [string]$BaseDir = "$env:APPDATA" # 默认 Roaming
    )
    $junction_path = Join-Path $BaseDir $RelativePath
    
    if (!(Test-Path $PersistDir)) { 
        New-Item -Path $PersistDir -ItemType Directory -Force | Out-Null 
    }

    # 清理并建立 Junction
    if (Test-Path $junction_path) {
        Remove-Item $junction_path -Recurse -Force -ErrorAction SilentlyContinue
    }
    # 确保父目录存在，否则 New-Item 会失败
    $parent = Split-Path $junction_path
    if (!(Test-Path $parent)) { New-Item $parent -ItemType Directory -Force | Out-Null }
    
    New-Item -ItemType Junction -Path $junction_path -Value $PersistDir | Out-Null

    # 处理 Local 下的 WebView2
    if ($WebViewName) {
        $local_webview = Join-Path "$env:LOCALAPPDATA" $WebViewName
        if (Test-Path $local_webview) { Remove-Item $local_webview -Recurse -Force }
    }
}