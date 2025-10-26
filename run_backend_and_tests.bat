@echo off
setlocal enabledelayedexpansion

echo ========================================
echo TestLang++ Backend and Tests Runner
echo ========================================
echo.

:: STEP 1: Check if backend is already running
echo Step 1: Checking if backend is already running...
netstat -an | findstr ":8080" >nul
if %errorlevel% == 0 (
    echo  Backend is already running on port 8080
) else (
    echo  Backend not detected, starting it...
    echo.
    echo Step 2: Starting Spring Boot Backend...
    start /B cmd /c "cd testlang-demo-backend && mvn spring-boot:run > backend.log 2>&1"

    echo Waiting for backend to start...
    ping 127.0.0.1 -n 8 >nul

    echo Checking if backend started successfully...
    netstat -an | findstr ":8080" >nul
    if not %errorlevel% == 0 (
        echo  Backend failed to start. Check backend.log for details.
        pause
        exit /b 1
    )
    echo  Backend started successfully on port 8080
)
echo.

:: STEP 3: Compile and Run Tests
if "%~1"=="" (
    echo Usage: %~nx0 ^<GeneratedTests.java^>
    echo Example: %~nx0 output\GeneratedTests.java
    pause
    exit /b 1
)

set "GENERATED_FILE=%~1"

if not exist "%GENERATED_FILE%" (
    echo Error: Generated test file '%GENERATED_FILE%' not found
    pause
    exit /b 1
)

echo.
echo Step 3: Preparing JUnit environment...

set "JUNIT_DIR=lib"
if not exist "%JUNIT_DIR%" mkdir "%JUNIT_DIR%"

set "JUNIT_JAR=%JUNIT_DIR%\junit-platform-console-standalone-1.10.0.jar"

if not exist "%JUNIT_JAR%" (
    echo Downloading JUnit 5...
    powershell -Command "Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.0/junit-platform-console-standalone-1.10.0.jar' -OutFile '%JUNIT_JAR%'"
)

set "TEST_BUILD=build\tests"
if not exist "%TEST_BUILD%" mkdir "%TEST_BUILD%"

echo.
echo === Compiling Generated Tests ===
javac -d "%TEST_BUILD%" -cp "%JUNIT_JAR%" "%GENERATED_FILE%"
if %errorlevel% neq 0 (
    echo ❌ Compilation failed.
    pause
    exit /b 1
)

echo.
echo === Running JUnit Tests ===
java -jar "%JUNIT_JAR%" --class-path "%TEST_BUILD%" --scan-class-path

echo.
echo ✓ Tests completed successfully!
pause
exit /b 0
