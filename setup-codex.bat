@echo off
setlocal EnableExtensions

set "SCRIPT_DIR=%~dp0"
set "LOG_FILE=%SCRIPT_DIR%setup-codex-windows.log"
set "OPEN_THESIS_NO_PS_PAUSE=1"

echo [INFO] Open Thesis Codex installer starting...
echo [INFO] Log file: "%LOG_FILE%"
echo [START] %DATE% %TIME% > "%LOG_FILE%"

set "OPEN_THESIS_INSTALL_LOG=%LOG_FILE%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%setup-codex.ps1" %*
set "EXIT_CODE=%ERRORLEVEL%"
set "OPEN_THESIS_INSTALL_LOG="
set "OPEN_THESIS_NO_PS_PAUSE="

if not "%EXIT_CODE%"=="0" (
  echo [ERROR] Installation failed (exit code %EXIT_CODE%).
  echo [ERROR] Please check log: "%LOG_FILE%"
) else (
  echo [SUCCESS] Installation completed successfully.
  echo [INFO] Detailed log: "%LOG_FILE%"
)
echo [END] %DATE% %TIME% >> "%LOG_FILE%"

echo.
echo Install finished. Press any key to close this window...
pause >nul

exit /b %EXIT_CODE%
