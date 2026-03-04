@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup.ps1" %*
if errorlevel 1 (
  echo.
  echo [ERROR] Installation failed.
  exit /b %errorlevel%
)

echo.
echo [INFO] Installation completed.
