$junction = Join-Path "$env:APPDATA" "dblab"

if (Test-Path "$junction") {
    $item = Get-Item "$junction"
    if ($item.Attributes -match 'ReparsePoint') {
        $item.Delete()
    }
}