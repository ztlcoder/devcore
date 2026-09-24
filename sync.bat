@echo off
cd /d "%~dp0"
git pull
git add --all
git commit -m "auto-backup: %date% %time%"
git push