@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   Parshwa EMR - Automated Publisher ^& Release Tool
echo ========================================================
echo.

set "SRC_DIR=C:\Users\Swapnil\Desktop\ParswhaEMR - Rust"
set "RELEASE_DIR=C:\Users\Swapnil\Desktop\ParshwaEMR-Releases"

echo [1/3] Building Rust Server and Inno Setup Installer...
cd /d "%SRC_DIR%"
call build-installer.bat -CompileInstaller
if errorlevel 1 (
    echo.
    echo ERROR: Build and installer compilation failed!
    pause
    exit /b 1
)

echo.
echo [2/3] Syncing files to Releases folder...
python scratch/copy_to_releases.py
if errorlevel 1 (
    echo.
    echo ERROR: Syncing files failed!
    pause
    exit /b 1
)

echo.
echo [3/3] Uploading updates to GitHub...
cd /d "%RELEASE_DIR%"

REM Find the version from version.json
set "VERSION="
for /f "tokens=2 delims=:," %%a in ('findstr "version" version.json') do (
    set "val=%%a"
    REM Strip spaces and quotes
    set "val=!val: =!"
    set "val=!val:"=!"
    set "VERSION=!val!"
)

if not defined VERSION (
    set "VERSION=latest"
)

echo Staging files...
git add -A

echo Committing version %VERSION%...
git commit -m "Release version %VERSION%"

echo Pushing to GitHub...
git push origin main
if errorlevel 1 (
    echo.
    echo ERROR: Git push failed!
    pause
    exit /b 1
)

echo.
echo ========================================================
echo   [SUCCESS] Release %VERSION% is now live!
echo ========================================================
echo.

REM Extract and display the installer download link from version.json
set "INSTALLER_URL="
for /f "tokens=2 delims=:," %%a in ('findstr "installer_url" version.json') do (
    set "raw=%%a"
    REM Strip spaces and quotes — handle the https: part split across tokens
    set "raw=!raw: =!"
    set "raw=!raw:"=!"
)
REM Reconstruct full URL (findstr splits on : so we need a different approach)
for /f "tokens=* delims=" %%a in ('python -c "import json; d=json.load(open('version.json')); print(d.get('installer_url','NOT FOUND'))"') do set "INSTALLER_URL=%%a"

echo ========================================================
echo   SHAREABLE INSTALLER DOWNLOAD LINK:
echo.
echo   !INSTALLER_URL!
echo.
echo   Send this link to clients to download the installer.
echo ========================================================
echo.
pause
