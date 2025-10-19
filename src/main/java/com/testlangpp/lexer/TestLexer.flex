/* ============================================================
   TestLang++ Lexer
   ------------------------------------------------------------
   A JFlex lexical analyzer for the TestLang++ DSL.
   This lexer tokenizes .test files containing API test
   definitions including configuration, HTTP requests, and
   assertions.
   ============================================================ */

package com.testlangpp.lexer;

%%

/* ============================================================
   JFLEX DIRECTIVES
   ============================================================ */

%class TestLexer       // Name of the generated Java class
%unicode                   // Support Unicode characters
%public                    // Make the class public
%standalone                // Generate a main method for standalone testing
%line                      // Track line numbers (accessible via yyline)
%column                    // Track column numbers (accessible via yycolumn)

/* User code section - can add custom fields/methods here */
%{
%}

/* ============================================================
   MACRO DEFINITIONS
   Regular expressions for token patterns
   ============================================================ */

/* Basic building blocks */
DIGIT = [0-9]                           // Single digit 0-9
NUMBER = {DIGIT}+                       // One or more digits (integers)

/* Identifier patterns */
ID_START = [A-Za-z_]                    // Valid identifier start: letter or underscore
ID_CONT = [A-Za-z0-9_]                  // Valid identifier continuation: alphanumeric or underscore
IDENT = {ID_START}{ID_CONT}*            // Complete identifier pattern

/* String literal patterns */
ESCAPED = \\[\"\\nrtbf/]                // Escape sequences: \", \\, \n, \r, \t, \b, \f, \/
STRCHAR = [^\"\\\n\r]                   // Any character except quote, backslash, newline, return
STRING = \"({STRCHAR}|{ESCAPED})*\"     // String: quoted text with optional escape sequences

/* Comment patterns */
COMMENT_SL = "//".*                                 // Single-line comment: // to end of line
COMMENT_ML = "/*"([^*]|\*+[^*/])*\*+"/"            // Multi-line comment: /* ... */

%%

/* ============================================================
   LEXICAL RULES
   Pattern matching rules that define tokens
   Format: <pattern> { <action> }
   ============================================================ */

/* ------------------------------------------------------------
   KEYWORDS - Configuration and test structure
   ------------------------------------------------------------ */
"config"        { System.out.println("TOKEN:CONFIG"); }      // Configuration block keyword
"base_url"      { System.out.println("TOKEN:BASE_URL"); }    // Base URL setting
"header"        { System.out.println("TOKEN:HEADER"); }      // HTTP header definition
"let"           { System.out.println("TOKEN:LET"); }         // Variable declaration
"test"          { System.out.println("TOKEN:TEST"); }        // Test case definition
"expect"        { System.out.println("TOKEN:EXPECT"); }      // Assertion keyword
"status"        { System.out.println("TOKEN:STATUS"); }      // HTTP status assertion
"body"          { System.out.println("TOKEN:BODY"); }        // Response body reference
"contains"      { System.out.println("TOKEN:CONTAINS"); }    // String containment check

/* ------------------------------------------------------------
   HTTP METHODS - REST API operations
   ------------------------------------------------------------ */
"GET"           { System.out.println("TOKEN:GET"); }         // HTTP GET request
"POST"          { System.out.println("TOKEN:POST"); }        // HTTP POST request
"PUT"           { System.out.println("TOKEN:PUT"); }         // HTTP PUT request
"DELETE"        { System.out.println("TOKEN:DELETE"); }      // HTTP DELETE request

/* ------------------------------------------------------------
   SYMBOLS - Punctuation and operators
   ------------------------------------------------------------ */
"{"             { System.out.println("TOKEN:LBRACE"); }      // Left brace - block start
"}"             { System.out.println("TOKEN:RBRACE"); }      // Right brace - block end
"="             { System.out.println("TOKEN:EQUALS"); }      // Assignment operator
";"             { System.out.println("TOKEN:SEMI"); }        // Statement terminator
".."            { System.out.println("TOKEN:DOTDOT"); }      // Range operator

/* ------------------------------------------------------------
   LITERALS - Numbers, identifiers, and strings
   ------------------------------------------------------------ */
{NUMBER}        { System.out.println("TOKEN:NUMBER:" + yytext()); }   // Numeric literal
{IDENT}         { System.out.println("TOKEN:IDENT:" + yytext()); }    // Identifier (variable/name)
{STRING}        { System.out.println("TOKEN:STRING:" + yytext()); }   // String literal

/* ------------------------------------------------------------
   COMMENTS - Ignored by lexer
   ------------------------------------------------------------ */
{COMMENT_SL}    { /* Single-line comment - ignore */ }
{COMMENT_ML}    { /* Multi-line comment - ignore */ }

/* ------------------------------------------------------------
   WHITESPACE - Ignored by lexer
   ------------------------------------------------------------ */
[ \t\r\n]+      { /* Whitespace (space, tab, newline) - ignore */ }

/* ------------------------------------------------------------
   ERROR HANDLING - Catch unrecognized characters
   ------------------------------------------------------------ */
.               { System.out.println("TOKEN:UNKNOWN:" + yytext()); }  // Any unmatched character