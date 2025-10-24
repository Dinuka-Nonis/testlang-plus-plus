@echo off
echo ========================================
echo TestLang++ Compiler Build Script
echo ========================================

echo.
echo Step 1: Cleaning up existing generated files...
echo Cleaning auto-generated files...
if exist "src\main\java\com\testlangpp\lexer\Lexer.java" del "src\main\java\com\testlangpp\lexer\Lexer.java"
if exist "src\main\java\com\testlangpp\lexer\Lexer.java~" del "src\main\java\com\testlangpp\lexer\Lexer.java~"
if exist "src\main\java\com\testlangpp\parser\Parser.java" del "src\main\java\com\testlangpp\parser\Parser.java"
if exist "src\main\java\com\testlangpp\parser\sym.java" del "src\main\java\com\testlangpp\parser\sym.java"
if exist "src\main\java\com\testlangpp\parser\Parser$CUP$Parser$actions.class" del "src\main\java\com\testlangpp\parser\Parser$CUP$Parser$actions.class"
if exist "GeneratedTests.java" del "GeneratedTests.java"
if exist "com" rmdir /s /q "com"
if exist "target" rmdir /s /q "target"
echo Cleanup completed.

echo.
echo Step 2: Generating Lexer from JFlex...
call jflex -d src\main\java\com\testlangpp\lexer src\main\java\com\testlangpp\lexer\lexer.flex
if errorlevel 1 (
    echo ERROR: JFlex generation failed!
    pause
    exit /b 1
)
echo JFlex generation completed successfully.

echo.
echo Step 3: Generating Parser from CUP...
call java -jar "D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b.jar" -destdir src\main\java\com\testlangpp\parser -parser Parser -symbols sym src\main\java\com\testlangpp\parser\parser.cup
if errorlevel 1 (
    echo ERROR: CUP generation failed!
    pause
    exit /b 1
)
echo CUP generation completed successfully.

echo.
echo Step 4: Compiling with Maven...
call mvn clean compile
if errorlevel 1 (
    echo ERROR: Maven compilation failed!
    pause
    exit /b 1
)
echo Maven compilation completed successfully.

echo.
echo Step 5: Running TestLang++ Compiler...
call java -cp "target\classes;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" com.testlangpp.Main
if errorlevel 1 (
    echo ERROR: TestLang++ execution failed!
    pause
    exit /b 1
)
echo TestLang++ execution completed successfully.

echo.
echo ========================================
echo SUCCESS! GeneratedTests.java created!
echo ========================================
pause
