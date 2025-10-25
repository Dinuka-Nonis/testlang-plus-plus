package com.testlangpp.lexer;

import java_cup.runtime.Symbol;
import com.testlangpp.parser.sym;

%%

%class Lexer
%public
%unicode
%cup
%line
%column

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline+1, yycolumn+1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline+1, yycolumn+1, value);
  }
  
  private void error(String message) {
    System.err.println("Lexical error at line " + (yyline+1) + 
                       ", column " + (yycolumn+1) + ": " + message);
  }
%}

//Regular Expression Definitions

/* Whitespace */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

/* Comments */
Comment = "//" [^\r\n]*

/* Identifiers */
Letter = [A-Za-z_]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit})*

/* Numbers */
Number = 0 | [1-9][0-9]*

/* Strings - handle escaped characters */
StringCharacter = [^\r\n\"\\]
StringEscape    = \\[\"\\nrtbf]
String          = \"({StringCharacter}|{StringEscape})*\"

%%

//LEXICAL RULES

/* Whitespace and Comments */
{WhiteSpace}    { /* ignore */ }
{Comment}       { /* ignore */ }

/* Keywords - MUST come before identifiers */
"config"        { return symbol(sym.CONFIG); }
"base_url"      { return symbol(sym.BASE_URL); }
"let"           { return symbol(sym.LET); }
"test"          { return symbol(sym.TEST); }
"expect"        { return symbol(sym.EXPECT); }
"status"        { return symbol(sym.STATUS); }
"header"        { return symbol(sym.HEADER); }
"body"          { return symbol(sym.BODY); }
"contains"      { return symbol(sym.CONTAINS); }

/* HTTP Methods */
"GET"           { return symbol(sym.GET); }
"POST"          { return symbol(sym.POST); }
"PUT"           { return symbol(sym.PUT); }
"DELETE"        { return symbol(sym.DELETE); }

/* Operators and Delimiters */
"{"             { return symbol(sym.LBRACE); }
"}"             { return symbol(sym.RBRACE); }
"="             { return symbol(sym.EQUALS); }
";"             { return symbol(sym.SEMI); }

/* Literals */
{Number} { 
  return symbol(sym.NUMBER, Integer.valueOf(yytext())); 
}

{String} {

  String raw = yytext();
  String content = raw.substring(1, raw.length() - 1);
  
  // Process escape sequences
  content = content.replace("\\\"", "\"")
                   .replace("\\\\", "\\")
                   .replace("\\n", "\n")
                   .replace("\\r", "\r")
                   .replace("\\t", "\t")
                   .replace("\\b", "\b")
                   .replace("\\f", "\f");
  
  return symbol(sym.STRING, content);
}

{Identifier} { 
  return symbol(sym.IDENT, yytext()); 
}

/* Error fallback */
[^] {
  error("Unexpected character: '" + yytext() + "'");
}