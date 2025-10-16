%%

%class SimpleLexer
%unicode
%public
%standalone
%line
%column

%%

// ----------------------------
// Token Rules
// ----------------------------

// String literals — text inside double quotes
\"([^\\\"]|\\.)*\"        { System.out.println("STRING: " + yytext()); }

// Numbers — one or more digits
[0-9]+                    { System.out.println("NUMBER: " + yytext()); }

// Identifiers — letters, numbers, or underscores (starting with letter/underscore)
[a-zA-Z_][a-zA-Z0-9_]*    { System.out.println("IDENTIFIER: " + yytext()); }

// Whitespace — spaces, tabs, newlines (ignored)
[ \t\r\n]+                { /* skip whitespace */ }

// Unknown characters — print for debugging
.                         { System.out.println("UNKNOWN: " + yytext()); }
