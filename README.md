#  TestLang++

**TestLang++** is a lightweight **Domain-Specific Language (DSL)** project written in Java.  
It transforms simple, human-readable `.test` files into executable **JUnit 5 test cases** for REST API validation.

The project combines compiler design concepts (scanning, parsing, and code generation) with modern testing tools — allowing developers to write test scenarios in plain text and automatically generate Java code.

---

##  Project Overview

The goal of TestLang++ is to:
- Parse a `.test` file written in a custom DSL
- Build an internal model (AST) from it
- Generate Java test code that uses `HttpClient` and `JUnit 5`

Example workflow:

DSL File (.test) → Parser → AST → com.testlangpp.generator.GeneratedTests.java → Run with JUnit

---

##  Tools & Technologies

| Tool | Purpose |
|------|----------|
| **Java 17** | Main programming language |
| **Maven** | Build automation and dependency management |
| **JFlex** | Lexical analyzer (scanner) generator |
| **CUP** | Parser generator for DSL grammar |
| **JUnit 5** | Testing framework for generated code |
| **HttpClient** | Executes HTTP requests in generated tests |
| **GitHub Actions** | Continuous Integration (CI) automation |

---

##  Getting Started

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/Dinuka-Nonis/testlang-plus-plus.git
cd testlang-plus-plus




                 ┌──────────────────────────────────────┐
                 │          Input File (.test)          │
                 │--------------------------------------│
                 │ config {                             │
                 │   base = "http://localhost:8080";    │
                 │ }                                    │
                 │ test "Get User" {                    │
                 │   GET /api/users/1;                  │
                 │   expect status = 200;               │
                 │ }                                    │
                 └──────────────────────────────────────┘
                                      │
                                      ▼
         ┌──────────────────────────────────────────────┐
         │           🔹 1️⃣ LEXICAL ANALYSIS (Scanner)  │
         │----------------------------------------------│
         │ Tool: JFlex                                 │
         │ Input: Characters from .test file            │
         │ Output: Tokens like:                         │
         │   TEST, STRING("Get User"), GET, PATH, ...   │
         └──────────────────────────────────────────────┘
                                      │
                                      ▼
         ┌──────────────────────────────────────────────┐
         │             🔹 2️⃣ PARSING (Syntax)          │
         │----------------------------------------------│
         │ Tool: CUP (like Yacc for Java)               │
         │ Input: Tokens from scanner                   │
         │ Grammar Rules: Defines DSL structure         │
         │ Output: Abstract Syntax Tree (AST)           │
         │   e.g. TestCase -> Request -> Expectation    │
         └──────────────────────────────────────────────┘
                                      │
                                      ▼
         ┌──────────────────────────────────────────────┐
         │           🔹 3️⃣ SEMANTIC ANALYSIS           │
         │----------------------------------------------│
         │ Tool: Java                                   │
         │ Checks: variable usage, duplicates, etc.     │
         │ Validates logical correctness of DSL code    │
         └──────────────────────────────────────────────┘
                                      │
                                      ▼
         ┌──────────────────────────────────────────────┐
         │           🔹 4️⃣ CODE GENERATION             │
         │----------------------------------------------│
         │ Tool: Java                                   │
         │ Reads AST and writes Java test code          │
         │ Output: com.testlangpp.generator.GeneratedTests.java                  │
         └──────────────────────────────────────────────┘
                                      │
                                      ▼
         ┌──────────────────────────────────────────────┐
         │              🔹 5️⃣ COMPILATION              │
         │----------------------------------------------│
         │ Tool: Maven / javac                          │
         │ Compiles com.testlangpp.generator.GeneratedTests.java                 │
         │ Output: Bytecode (.class files)              │
         └──────────────────────────────────────────────┘
                                      │
                                      ▼
         ┌──────────────────────────────────────────────┐
         │              🔹 6️⃣ EXECUTION                │
         │----------------------------------------------│
         │ Tool: JUnit 5                                │
         │ Runs HTTP tests using HttpClient             │
         │ Validates responses, asserts status codes    │
         │ Output: Pass/Fail results                    │
         └──────────────────────────────────────────────┘

---

##  Quick Start

### Option 1: All-in-One (Recommended)
Run backend and tests together:
```bash
.\run_backend_and_tests.bat
```

### Option 2: Manual Steps
1. **Build the project:**
   ```bash
   .\build_and_run.bat
   ```

2. **Start backend manually:**
   ```bash
   cd testlang-demo-backend
   mvn spring-boot:run
   ```

3. **Run tests:**
   ```bash
   .\run_tests_only.bat
   ```

### Option 3: Stop Backend
```bash
.\stop_backend.bat
```

---

##  Manual Build Process

# Clean generated files
Remove-Item src\main\java\com\testlangpp\lexer\Lexer.java -ErrorAction SilentlyContinue
Remove-Item src\main\java\com\testlangpp\parser\Parser.java -ErrorAction SilentlyContinue
Remove-Item src\main\java\com\testlangpp\parser\sym.java -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force com -ErrorAction SilentlyContinue

# Generate Lexer
jflex -d src\main\java\com\testlangpp\lexer src\main\java\com\testlangpp\lexer\Lexer.flex

# Generate Parser
java -jar "D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b.jar" -destdir src\main\java\com\testlangpp\parser -parser Parser -symbols sym src\main\java\com\testlangpp\parser\Parser.cup

# Compile in order
javac -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" -d . src\main\java\com\testlangpp\model\*.java

javac -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" -d . src\main\java\com\testlangpp\parser\sym.java

javac -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" -d . src\main\java\com\testlangpp\lexer\Lexer.java

javac -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" -d . src\main\java\com\testlangpp\parser\Parser.java