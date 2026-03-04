@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "LOG_FILE=%SCRIPT_DIR%setup-windows.log"
set "NO_PAUSE=0"

echo %* | findstr /I /C:"--no-pause" >nul && set "NO_PAUSE=1"

echo [INFO] Open Thesis installer starting...
echo [INFO] Log file: "%LOG_FILE%"
echo [START] %DATE% %TIME% > "%LOG_FILE%"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup.ps1" %* >> "%LOG_FILE%" 2>&1
set "EXIT_CODE=%ERRORLEVEL%"

if not "%EXIT_CODE%"=="0" (
  echo [ERROR] Installation failed (exit code %EXIT_CODE%).
  echo [ERROR] Please check log: "%LOG_FILE%"
) else (
  echo [INFO] Installation completed successfully.
  echo [INFO] Detailed log: "%LOG_FILE%"
)

if "%NO_PAUSE%"=="0" (
  echo.
  echo Press any key to close this window...
  pause >nul
)

exit /b %EXIT_CODE%
