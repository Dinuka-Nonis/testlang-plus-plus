@echo off
echo ========================================
echo TestLang++ Backend Stopper
echo ========================================
echo.

echo Stopping Spring Boot Backend...
taskkill /f /im java.exe 2>nul
if %errorlevel% == 0 (
    echo  Backend stopped successfully
) else (
    echo   No backend process found or already stopped
)

echo.
echo Checking if port 8080 is free...
netstat -an | findstr ":8080" >nul
if %errorlevel% == 0 (
    echo   Port 8080 is still in use. You may need to restart your computer.
) else (
    echo  Port 8080 is now free
)

echo.
echo ========================================
echo Backend Stop Complete
echo ========================================
pause
