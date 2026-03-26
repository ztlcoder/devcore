$paths = @(
    Join-Path "$env:APPDATA" "debba\tabularis",
    Join-Path "$env:LOCALAPPDATA" "tabularis"
)

foreach ($path in $paths) {
    if (Test-Path $path) {
        $item = Get-Item $path
        if ($item.Attributes -match 'ReparsePoint') { $item.Delete() }
        else { Remove-Item $path -Recurse -Force -ErrorAction SilentlyContinue }
    }
}