/* ============================================================
   TestLang++ File Structure Lexer
   ------------------------------------------------------------
   Recognizes config, let, and test blocks.
   ============================================================ */

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
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
%}

/* Regular expressions */
Letter = [A-Za-z_]
Digit = [0-9]
Ident = {Letter}({Letter}|{Digit})*
Number = {Digit}+
Whitespace = [ \t\r\n]+
String = \"[^\"]*\"

/* Escape-aware string handling */
ESC = \\.
STRCHAR = ([^\"\\\r\n] | {ESC})
STRING = \"({STRCHAR})*\"

%%

/* Keywords */
"config"      { return symbol(sym.CONFIG); }
"base_url"    { return symbol(sym.BASE_URL); }
"let"         { return symbol(sym.LET); }
"test"        { return symbol(sym.TEST); }
"GET"         { return symbol(sym.GET); }
"POST"        { return symbol(sym.POST); }
"PUT"         { return symbol(sym.PUT); }
"DELETE"      { return symbol(sym.DELETE); }
"expect"      { return symbol(sym.EXPECT); }
"status"      { return symbol(sym.STATUS); }
"header"      { return symbol(sym.HEADER); }
"body"        { return symbol(sym.BODY); }
"contains"    { return symbol(sym.CONTAINS); }

/* Operators */
"="           { return symbol(sym.EQUALS); }
";"           { return symbol(sym.SEMI); }
"{"           { return symbol(sym.LBRACE); }
"}"           { return symbol(sym.RBRACE); }

/* Identifiers and literals */
{Ident}       { return symbol(sym.IDENT, yytext()); }
{Number}      { return symbol(sym.NUMBER, Integer.parseInt(yytext())); }
{STRING} {
    String raw = yytext(); // includes surrounding quotes
    // remove surrounding quotes
    String inner = raw.substring(1, raw.length() - 1);
    // unescape common sequences: \" -> ", \\ -> \, \n -> newline, etc.
    inner = inner.replace("\\\"", "\"").replace("\\\\", "\\")
                 .replace("\\n", "\n").replace("\\r", "\r")
                 .replace("\\t", "\t").replace("\\b", "").replace("\\f", "");
    return symbol(sym.STRING, inner);
}
/* Skip whitespace */
{Whitespace}  { /* ignore */ }

/* Any other character */
.             { System.err.println("Illegal character: " + yytext()); }