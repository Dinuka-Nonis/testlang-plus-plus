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

DSL File (.test) → Parser → AST → GeneratedTests.java → Run with JUnit

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
         │ Output: GeneratedTests.java                  │
         └──────────────────────────────────────────────┘
                                      │
                                      ▼
         ┌──────────────────────────────────────────────┐
         │              🔹 5️⃣ COMPILATION              │
         │----------------------------------------------│
         │ Tool: Maven / javac                          │
         │ Compiles GeneratedTests.java                 │
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

