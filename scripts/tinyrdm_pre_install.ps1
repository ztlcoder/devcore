# 加载通用工具函数
. "$bucketsdir\devcore\scripts\utils.ps1"

# 执行重定向逻辑
# -AppName: 软件存储配置的文件夹名
# -PersistDir: Scoop 提供的持久化目录变量
# -WebViewName: WebView2 运行时产生的缓存文件夹名
Redirect-AppData -AppName "TinyRDM" -PersistDir "$persist_dir" -WebViewName "Tiny RDM.exe"