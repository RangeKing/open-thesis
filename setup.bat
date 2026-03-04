@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "SCRIPT_DIR=%~dp0"
set "LOG_FILE=%SCRIPT_DIR%setup-windows.log"
set "NO_PAUSE=0"
set "OPEN_THESIS_NO_PS_PAUSE=1"

for %%A in (%*) do (
  if /I "%%~A"=="--no-pause" set "NO_PAUSE=1"
)

echo [INFO] Open Thesis installer starting...
echo [INFO] Log file: "%LOG_FILE%"
echo [START] %DATE% %TIME% > "%LOG_FILE%"

set "OPEN_THESIS_INSTALL_LOG=%LOG_FILE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup.ps1" %*
set "EXIT_CODE=%ERRORLEVEL%"
set "OPEN_THESIS_INSTALL_LOG="
set "OPEN_THESIS_NO_PS_PAUSE="

if not "%EXIT_CODE%"=="0" (
  echo [ERROR] Installation failed (exit code %EXIT_CODE%).
  echo [ERROR] Please check log: "%LOG_FILE%"
) else (
  echo [SUCCESS] 安装成功 (Installation completed successfully).
  echo [INFO] Detailed log: "%LOG_FILE%"
)
echo [END] %DATE% %TIME% >> "%LOG_FILE%"

if "%NO_PAUSE%"=="0" (
  echo.
  echo Install finished. Press any key to close this window...
  pause >nul
)

exit /b %EXIT_CODE%
