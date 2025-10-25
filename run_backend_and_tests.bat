@echo off
echo ========================================
echo TestLang++ Backend and Tests Runner
echo ========================================
echo.

echo Step 1: Checking if backend is already running...
netstat -an | findstr ":8080" >nul
if %errorlevel% == 0 (
    echo  Backend is already running on port 8080
    goto :run_tests
) else (
    echo   Backend not detected, starting it...
)

echo.
echo Step 2: Starting Spring Boot Backend...
echo Starting backend server in background...
start /B cmd /c "cd testlang-demo-backend && mvn spring-boot:run > backend.log 2>&1"

echo Waiting for backend to start...
ping 127.0.0.1 -n 8 >nul

echo Checking if backend started successfully...
netstat -an | findstr ":8080" >nul
if %errorlevel% == 0 (
    echo  Backend started successfully on port 8080
) else (
    echo  Backend failed to start. Check backend.log for details.
    pause
    exit /b 1
)

:run_tests
echo.
echo Step 3: Generating and Running Tests...
echo ========================================

echo  Generating tests from TestLang++ DSL...
call java -cp "target\classes;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" com.testlangpp.Main
if errorlevel 1 (
    echo  Test generation failed!
    pause
    exit /b 1
)
echo  Tests generated successfully

echo.
echo  Running Generated Tests...
echo ========================================
call mvn test -Dtest=GeneratedTests -q
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
    echo Backend is working correctly with TestLang++ DSL.
) else (
    echo.
    echo  SOME TESTS FAILED!
    echo ========================================
    echo Check the detailed output above for specific failures.
    echo Common issues:
    echo - Backend not running on port 8080
    echo - Network connectivity issues
    echo - JSON format mismatches
)

echo.
echo ========================================
echo Test Execution Complete
echo ========================================
echo.
echo 💡 Tips:
echo - Backend logs are saved in: testlang-demo-backend\backend.log
echo - Test reports are in: target\surefire-reports\
echo - To stop backend: Close the backend window or Ctrl+C
echo.
pause
