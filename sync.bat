@echo off
cd /d "%~dp0"
git pull
git add --all
git commit -m "devcore-backup: %date% %time%"
git push