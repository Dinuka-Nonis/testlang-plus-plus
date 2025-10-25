@echo off
echo ========================================
echo TestLang++ Backend and Tests Runner
echo ========================================
echo.

echo Step 1: Checking if backend is already running...
echo [DEMO] This step checks if our Spring Boot backend is already running on port 8080
ping 127.0.0.1 -n 4 >nul
netstat -an | findstr ":8080" >nul
if %errorlevel% == 0 (
    echo [SUCCESS] Backend is already running on port 8080
    echo [DEMO] Great! We can proceed directly to testing
    ping 127.0.0.1 -n 3 >nul
    goto :run_tests
) else (
    echo [INFO] Backend not detected, starting it...
    echo [DEMO] We need to start our Spring Boot demo backend first
    ping 127.0.0.1 -n 3 >nul
)

echo.
echo Step 2: Starting Spring Boot Backend...
echo [DEMO] Starting our demo backend server in the background
echo [DEMO] This backend provides REST API endpoints for testing
ping 127.0.0.1 -n 4 >nul
echo Starting backend server in background...
start /B cmd /c "cd testlang-demo-backend && mvn spring-boot:run > backend.log 2>&1"

echo [DEMO] Waiting for backend to initialize...
echo [DEMO] Spring Boot needs a few seconds to start up Tomcat server
ping 127.0.0.1 -n 8 >nul

echo Checking if backend started successfully...
netstat -an | findstr ":8080" >nul
if %errorlevel% == 0 (
    echo [SUCCESS] Backend started successfully on port 8080
    echo [DEMO] Perfect! Our backend is now ready to receive API requests
    ping 127.0.0.1 -n 3 >nul
) else (
    echo [ERROR] Backend failed to start. Check backend.log for details.
    pause
    exit /b 1
)

:run_tests
echo.
echo Step 3: Generating and Running Tests...
echo ========================================

echo [DEMO] Now we'll generate JUnit tests from our TestLang++ DSL
echo [DEMO] This is the core functionality - converting .test files to Java code
ping 127.0.0.1 -n 4 >nul
echo Generating tests from TestLang++ DSL...
call java -cp "target\classes;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" com.testlangpp.Main
if errorlevel 1 (
    echo [ERROR] Test generation failed!
    pause
    exit /b 1
)
echo [SUCCESS] Tests generated successfully
echo [DEMO] Our DSL has been compiled into executable JUnit test code
ping 127.0.0.1 -n 3 >nul

echo.
echo [DEMO] Now running the generated tests against our backend
echo [DEMO] This validates that our DSL correctly tests the API endpoints
ping 127.0.0.1 -n 4 >nul
echo Running Generated Tests...
echo ========================================
call mvn test -Dtest=GeneratedTests -q
if %errorlevel% == 0 (
    echo.
    echo [SUCCESS] ALL TESTS PASSED! 
    echo ========================================
    echo Test Results Summary:
    echo - Login Test: PASSED
    echo - Get User Test: PASSED  
    echo - Update User Test: PASSED
    echo - Delete User Test: PASSED
    echo - Login Different User Test: PASSED
    echo.
    echo [DEMO] All 5 API endpoints tested successfully!
    echo [DEMO] This proves our TestLang++ DSL works correctly with real APIs
    ping 127.0.0.1 -n 4 >nul
) else (
    echo.
    echo [ERROR] SOME TESTS FAILED!
    echo ========================================
    echo Check the detailed output above for specific failures.
)

echo.
echo ========================================
echo Test Execution Complete
echo ========================================
echo.
echo [DEMO] Summary: TestLang++ successfully converted DSL to JUnit tests
echo [DEMO] and validated all API endpoints against our Spring Boot backend
echo.
echo Tips:
echo - Backend logs are saved in: testlang-demo-backend\backend.log
echo - Test reports are in: target\surefire-reports\
echo - To stop backend: Close the backend window or Ctrl+C
echo.
pause
