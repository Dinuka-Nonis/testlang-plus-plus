@echo off
echo ========================================
echo TestLang++ Quick Test Runner
echo ========================================
echo.

echo Step 1: Checking if backend is running...
netstat -an | findstr ":8080" >nul
if %errorlevel% == 0 (
    echo  Backend detected on port 8080
) else (
    echo  Backend not running on port 8080!
    echo Please start the backend first using: run_backend_and_tests.bat
    pause
    exit /b 1
)

echo.
echo Step 2: Generating Tests...
echo  Generating tests from TestLang++ DSL...
call java -cp "target\classes;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" com.testlangpp.Main
if errorlevel 1 (
    echo  Test generation failed!
    pause
    exit /b 1
)
echo  Tests generated successfully

echo.
echo Step 3: Running Tests...
echo  Running Generated Tests...
echo ========================================
call mvn test -Dtest=GeneratedTests
if %errorlevel% == 0 (
    echo.
    echo  ALL TESTS PASSED! 
    echo ========================================
    echo Test Results Summary:
    echo - Login Test:  PASSED
    echo - Get User Test:  PASSED  
    echo - Update User Test:  PASSED
    echo - Delete User Test:  PASSED
    echo - Login Different User Test:  PASSED
    echo.
    echo  All 5 API endpoints tested successfully!
) else (
    echo.
    echo  SOME TESTS FAILED!
    echo ========================================
    echo Check the detailed output above for specific failures.
)

echo.
pause
