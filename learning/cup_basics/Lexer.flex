/* ============================================================
   Simple Lexer for CUP Learning
   ------------------------------------------------------------
   Recognizes: let IDENT = STRING;
   ============================================================ */

import java_cup.runtime.Symbol;

%%

%class Lexer
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

%%

/* Keywords */
"let"        { return symbol(sym.LET); }

/* Operators */
"="          { return symbol(sym.EQUALS); }
";"          { return symbol(sym.SEMI); }

/* Identifiers */
{Ident}      { return symbol(sym.IDENT, yytext()); }

/* String literals - matches anything between quotes */
\"[^\"]*\"   { 
    String str = yytext();
    // Remove surrounding quotes
    return symbol(sym.STRING, str.substring(1, str.length()-1)); 
}

/* Skip whitespace */
{Whitespace} { /* ignore */ }

/* Any other character */
.            { 
    System.err.println("Illegal character: " + yytext() + " at line " + (yyline+1) + ", column " + (yycolumn+1)); 
}