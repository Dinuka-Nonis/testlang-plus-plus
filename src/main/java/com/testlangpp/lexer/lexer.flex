/* TestLang++ Lexer (JFlex) */

import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
  private Symbol symbol(int type) {
    return new Symbol(type, yyline + 1, yycolumn + 1);
  }

  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline + 1, yycolumn + 1, value);
  }
%}

/* Regular Expressions */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]
LineComment    = "//" [^\r\n]*

Identifier     = [A-Za-z_][A-Za-z0-9_]*
Number         = 0 | [1-9][0-9]*
StringChar     = [^\"\\\r\n]
String         = \"({StringChar}|\\[\"\\])*\"

%%

/* Keywords */
"config"       { return symbol(sym.CONFIG); }
"base_url"     { return symbol(sym.BASE_URL); }
"header"       { return symbol(sym.HEADER); }
"let"          { return symbol(sym.LET); }
"test"         { return symbol(sym.TEST); }
"GET"          { return symbol(sym.GET); }
"POST"         { return symbol(sym.POST); }
"PUT"          { return symbol(sym.PUT); }
"DELETE"       { return symbol(sym.DELETE); }
"expect"       { return symbol(sym.EXPECT); }
"status"       { return symbol(sym.STATUS); }
"body"         { return symbol(sym.BODY); }
"contains"     { return symbol(sym.CONTAINS); }

/* Literals */
{Identifier}   { return symbol(sym.IDENT, yytext()); }
{Number}       { return symbol(sym.NUMBER, Integer.parseInt(yytext())); }
{String}       { 
  // Remove quotes and handle escape sequences
  String str = yytext();
  str = str.substring(1, str.length() - 1); // Remove surrounding quotes
  str = str.replace("\\\"", "\"");
  str = str.replace("\\\\", "\\");
  return symbol(sym.STRING, str);
}

/* Operators and Delimiters */
"{"            { return symbol(sym.LBRACE); }
"}"            { return symbol(sym.RBRACE); }
"="            { return symbol(sym.EQUALS); }
";"            { return symbol(sym.SEMI); }
".."           { return symbol(sym.DOTDOT); }

/* Variable Reference (inside strings will be handled by parser) */
"$"            { return symbol(sym.DOLLAR); }

/* Whitespace and Comments */
{WhiteSpace}   { /* ignore */ }
{LineComment}  { /* ignore */ }

/* Error fallback */
[^]            { 
  throw new Error("Illegal character <" + yytext() + "> at line " + (yyline + 1) + ", column " + (yycolumn + 1)); 
}