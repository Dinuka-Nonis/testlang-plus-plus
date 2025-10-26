@echo off
REM Compile and run the generated JUnit tests

if "%1"=="" (
    echo Usage: %0 ^<GeneratedTests.java^>
    echo Example: %0 output\GeneratedTests.java
    pause
    exit /b 1
)

set GENERATED_FILE=%1

if not exist "%GENERATED_FILE%" (
    echo Error: Generated test file '%GENERATED_FILE%' not found
    pause
    exit /b 1
)

REM Download JUnit 5 JARs if not present
set JUNIT_DIR=lib
if not exist "%JUNIT_DIR%" mkdir "%JUNIT_DIR%"

if not exist "%JUNIT_DIR%\junit-platform-console-standalone-1.10.0.jar" (
    echo Downloading JUnit 5...
    powershell -Command "Invoke-WebRequest -Uri 'https://repo1.maven.org/maven2/org/junit/platform/junit-platform-console-standalone/1.10.0/junit-platform-console-standalone-1.10.0.jar' -OutFile '%JUNIT_DIR%\junit-platform-console-standalone-1.10.0.jar'"
)

set JUNIT_JAR=%JUNIT_DIR%\junit-platform-console-standalone-1.10.0.jar
set TEST_BUILD=build\tests
if not exist "%TEST_BUILD%" mkdir "%TEST_BUILD%"

echo === Compiling Generated Tests ===
javac -d "%TEST_BUILD%" -cp "%JUNIT_JAR%" "%GENERATED_FILE%"

echo.
echo === Running JUnit Tests ===
java -jar "%JUNIT_JAR%" --class-path "%TEST_BUILD%" --scan-class-path

echo.
echo ✓ Tests completed!
pause