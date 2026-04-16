@echo off
fltmc >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "%~s0", "", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /b
)
echo [1/3] Stopping IDM Process...
taskkill /f /im idman.exe >nul 2>&1
echo [2/3] Cleaning Standard Registry Keys...
reg delete "HKCU\Software\DownloadManager" /v "FName" /f >nul 2>&1
reg delete "HKCU\Software\DownloadManager" /v "LName" /f >nul 2>&1
reg delete "HKCU\Software\DownloadManager" /v "Email" /f >nul 2>&1
reg delete "HKCU\Software\DownloadManager" /v "Serial" /f >nul 2>&1
reg delete "HKCU\Software\DownloadManager" /v "tvfrdt" /f >nul 2>&1
reg delete "HKCU\Software\DownloadManager" /v "LastCheckQU" /f >nul 2>&1
echo [3/3] Searching for Hidden Tracking Keys...
set "regpath=HKCU:\Software\Classes\CLSID"
if exist "%SystemRoot%\SysWOW64" set "regpath=HKCU:\Software\Classes\Wow6432Node\CLSID"
powershell -NoProfile -Command "& {Get-ChildItem '%regpath%' -ErrorAction SilentlyContinue | ForEach-Object {$k = $_.Name; $v = Get-ItemProperty -Path \"Registry::$k\" -ErrorAction SilentlyContinue; if ($v.MData -or $v.Model -or $v.scansk -or $v.Therad) { Remove-Item -Path \"Registry::$k\" -Recurse -Force; Write-Host \"Cleared: $k\" }}}"
echo.
echo Trial Reset Complete. Please restart your PC if the status hasn't updated.
pause
