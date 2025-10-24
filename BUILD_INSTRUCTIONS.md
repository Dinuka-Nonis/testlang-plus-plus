# TestLang++ Build Instructions

## Quick Start

### Option 1: Windows Batch Script (Default - uses input.test)
```bash
.\build_and_run.bat
```

### Option 2: Flexible Script (Choose test file)
```bash
.\build_with_file.bat input.test
.\build_with_file.bat comprehensive_test.test
```

### Option 3: PowerShell Script
```powershell
.\build_and_run.ps1
```

### Option 4: Manual Commands
```bash
# 1. Clean up existing files
jflex -d src\main\java\com\testlangpp\lexer src\main\java\com\testlangpp\lexer\lexer.flex
java -jar "D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b.jar" -destdir src\main\java\com\testlangpp\parser -parser Parser -symbols sym src\main\java\com\testlangpp\parser\parser.cup
mvn clean compile
java -cp "target\classes;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" com.testlangpp.Main
```

## What the Scripts Do

1. **Clean up** all auto-generated files (Lexer.java, Parser.java, sym.java, .class files)
2. **Generate Lexer** from JFlex specification
3. **Generate Parser** from CUP specification
4. **Compile** the entire project with Maven
5. **Run** the TestLang++ compiler from Main.java
6. **Generate** GeneratedTests.java

## Available Test Files

- **`input.test`** - Basic test suite (4 tests)
- **`comprehensive_test.test`** - Complete test suite (5 tests)

## Script Options

- **`build_and_run.bat`** - Uses default `input.test`
- **`build_with_file.bat [filename]`** - Choose specific test file
- **`build_and_run.ps1`** - PowerShell version

## Output

After successful execution, you'll get:
- ✅ **GeneratedTests.java** - Complete JUnit 5 test suite
- 📊 **Console output** showing parsing results and variable substitution

## Prerequisites

- Java 17+
- Maven
- JFlex
- CUP (Java Cup)
- Windows PowerShell or Command Prompt

## File Structure

```
testlang-plus-plus/
├── build_and_run.bat          # Windows batch script
├── build_and_run.ps1         # PowerShell script
├── GeneratedTests.java        # Generated JUnit tests
└── src/main/java/com/testlangpp/
    ├── Main.java              # Main entry point
    ├── lexer/
    │   ├── lexer.flex         # JFlex specification
    │   └── comprehensive_test.test  # Input test file
    ├── parser/
    │   └── parser.cup          # CUP specification
    ├── model/                 # AST classes
    └── generator/
        └── TestGenerator.java # Code generator
```

## Troubleshooting

- **JFlex not found**: Ensure JFlex is in your PATH
- **CUP JAR not found**: Update the path in the scripts
- **Maven compilation fails**: Check Java version (requires Java 17+)
- **Parsing errors**: Check your .test file syntax
- **Script stops after JFlex**: This was fixed by adding `call` commands to properly execute external programs
