{
    "version": "18.6-5",
    "description": "Object-relational database management system based on POSTGRES.",
    "homepage": "https://www.postgresql.org",
    "license": "PostgreSQL",
    "notes": [
        "Run 'pg_ctl start' to start the database and 'pg_ctl stop' to stop it.",
        "Register it as a service by running 'pg_ctl register -N PostgreSQL -D $persist_dir\\postgresql\\data' from an elevated shell.",
        "Add service description by running 'sc.exe description PostgreSQL PostgreSQL-Database-Server' from an elevated shell.",
        "Default superuser login: postgres, password: <blank>",
        "WARNING: Uninstalling this package deletes the PostgreSQL database and all persisted data."
    ],
    "architecture": {
        "64bit": {
            "url": "https://get.enterprisedb.com/postgresql/postgresql-18.6-5-windows-x64-binaries.zip",
            "hash": "e2246ba91d22345bc3d017586c09ede52d9df180b1eeb480f050445f1cad84e2"
        }
    },
    "extract_dir": "pgsql",
    "pre_install": [
        "if (-not (Test-Path -LiteralPath (Join-Path $persist_dir 'postgresql'))) {",
        "    New-Item -ItemType Directory -Path (Join-Path $dir 'postgresql\\data') -Force | Out-Null",
        "}"
    ],
    "post_install": [
        "$dataDir = Join-Path $dir 'postgresql\\data'",
        "if (-not (Test-Path (Join-Path $dataDir 'PG_VERSION'))) {",
        "    Invoke-ExternalCommand -FilePath (Join-Path $dir 'bin\\initdb.exe') -ArgumentList @('--username=postgres', '--encoding=UTF8', '--locale=C', ('--pgdata=' + $dataDir)) | Out-Null",
        "}"
    ],
    "pre_uninstall": [
        "if ($cmd -eq 'uninstall') {",
        "    $service = Get-Service -Name 'PostgreSQL' -ErrorAction SilentlyContinue",
        "    if ($service -and $service.Status -eq 'Running') {",
        "        Stop-Service -Name 'PostgreSQL' -Force -ErrorAction SilentlyContinue",
        "    }",
        "}"
    ],
    "post_uninstall": [
        "if ($cmd -eq 'uninstall') {",
        "    $persistData = Join-Path $persist_dir 'postgresql'",
        "    if (Test-Path -LiteralPath $persistData) {",
        "        Remove-Item -LiteralPath $persistData -Recurse -Force",
        "    }",
        "    if ($env:APPDATA) {",
        "        $appData = Join-Path $env:APPDATA 'PostgreSQL'",
        "        if (Test-Path -LiteralPath $appData) {",
        "            Remove-Item -LiteralPath $appData -Recurse -Force",
        "        }",
        "    }",
        "}"
    ],
    "shortcuts": [
        [
            "pgAdmin 4\\runtime\\pgAdmin4.exe",
            "pgAdmin 4"
        ]
    ],
    "env_add_path": "bin",
    "env_set": {
        "PGDATA": "$dir\\postgresql\\data",
        "PG_LIB_DIR": "$dir\\lib",
        "PG_INCLUDE_DIR": "$dir\\include"
    },
    "persist": "postgresql",
    "checkver": {
        "url": "https://www.enterprisedb.com/downloads/postgres-postgresql-downloads",
        "script": [
            "$url = ([xml]$page).SelectSingleNode('//table/tbody/tr[1]/td[5]/a').href",
            "$request = [System.Net.HttpWebRequest]::Create($url)",
            "$request.UserAgent = (Get-UserAgent)",
            "$response = $request.GetResponse()",
            "Write-Output $response.ResponseUri.AbsoluteUri"
        ],
        "regex": "postgresql-(?<version>\\d+\\.\\d+-\\d+)-windows"
    },
    "autoupdate": {
        "architecture": {
            "64bit": {
                "url": "https://get.enterprisedb.com/postgresql/postgresql-$version-windows-x64-binaries.zip"
            }
        }
    }
}