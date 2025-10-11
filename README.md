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





