Write-Host "========================================" -ForegroundColor Cyan
Write-Host "TestLang++ Compiler Build Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Step 1: Cleaning up existing generated files..." -ForegroundColor Yellow

# Clean up generated files
if (Test-Path "src\main\java\com\testlangpp\lexer\Lexer.java") { Remove-Item "src\main\java\com\testlangpp\lexer\Lexer.java" }
if (Test-Path "src\main\java\com\testlangpp\parser\Parser.java") { Remove-Item "src\main\java\com\testlangpp\parser\Parser.java" }
if (Test-Path "src\main\java\com\testlangpp\parser\sym.java") { Remove-Item "src\main\java\com\testlangpp\parser\sym.java" }
if (Test-Path "GeneratedTests.java") { Remove-Item "GeneratedTests.java" }
if (Test-Path "com") { Remove-Item -Recurse -Force "com" }
if (Test-Path "target") { Remove-Item -Recurse -Force "target" }

Write-Host ""
Write-Host "Step 2: Generating Lexer from JFlex..." -ForegroundColor Yellow
jflex -d src\main\java\com\testlangpp\lexer src\main\java\com\testlangpp\lexer\lexer.flex
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: JFlex generation failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 3: Generating Parser from CUP..." -ForegroundColor Yellow
java -jar "D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b.jar" -destdir src\main\java\com\testlangpp\parser -parser Parser -symbols sym src\main\java\com\testlangpp\parser\parser.cup
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: CUP generation failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 4: Compiling with Maven..." -ForegroundColor Yellow
mvn clean compile
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Maven compilation failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "Step 5: Running TestLang++ Compiler..." -ForegroundColor Yellow
java -cp "target\classes;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" com.testlangpp.Main
if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: TestLang++ execution failed!" -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "SUCCESS! GeneratedTests.java created!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Read-Host "Press Enter to exit"
