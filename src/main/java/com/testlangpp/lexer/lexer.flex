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
Whitespace = [ \t\r\n]+
String = \"[^\"]*\"

%%

/* Keywords */
"config"      { return symbol(sym.CONFIG); }
"base_url"    { return symbol(sym.BASE_URL); }
"let"         { return symbol(sym.LET); }
"test"        { return symbol(sym.TEST); }
"GET"         { return symbol(sym.GET); }
"expect"      { return symbol(sym.EXPECT); }
"status"      { return symbol(sym.STATUS); }

/* Operators */
"="           { return symbol(sym.EQUALS); }
";"           { return symbol(sym.SEMI); }
"{"           { return symbol(sym.LBRACE); }
"}"           { return symbol(sym.RBRACE); }

/* Identifiers and literals */
{Ident}       { return symbol(sym.IDENT, yytext()); }
{String}      { return symbol(sym.STRING, yytext().substring(1, yytext().length() - 1)); }

/* Skip whitespace */
{Whitespace}  { /* ignore */ }

/* Any other character */
.             { System.err.println("Illegal character: " + yytext()); }