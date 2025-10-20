# CUP Basics — TestLang++ Learning

This folder demonstrates a minimal working example of a **JFlex lexer** and **CUP parser**.

---

## Purpose

To understand how lexical analysis and parsing work together in TestLang++.  
This example only supports the syntax:
```text
let IDENT = STRING;
```

For example:
```text
let user = "Nonis";
let name = "value";
```

---

## Files

- **Lexer.flex** - JFlex lexer specification (tokenizer)
- **Parser.cup** - CUP parser specification (grammar rules)
- **input.test** - Sample input file for testing

---

## Clean Up Auto-Generated Files

Before regenerating or starting fresh, delete all auto-generated files:
```powershell
del Lexer.java
del Parser.java
del sym.java
del *.class
```

---

## ⚙️ Build Process

### Generate Lexer from JFlex

```powershell
jflex Lexer.flex
```


**Expected output:**
```
Reading "Lexer.flex"
...
Writing code to "Lexer.java"
```

---

### Generate Parser from CUP
```powershell
java -jar "D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b.jar" -parser Parser -symbols sym Parser.cup
```

**Expected output:**
```
------- CUP v0.11b ... Parser Generation Summary -------
  0 errors and 0 warnings
  ...
```

---

### Compile Generated Files

Compile in the following order:
```powershell
# Compile symbol table
javac -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" sym.java

# Compile lexer
javac -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" Lexer.java

# Compile parser
javac -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" Parser.java
```

---

## Running the Parser

``` 
Get-Content input.test | java -cp ".;D:\SLIIT\semester_4\PP\ASSIGNMENT\java-cup-bin-11b-20160615\java-cup-11b-runtime.jar" Parser
```

**Expected output:**
```
Enter: let name = "value";
Parsed LET statement: user = Nonis
```
