package de.thm.mni.compilerbau.phases._01_scanner;

import de.thm.mni.compilerbau.utils.SplError;
import de.thm.mni.compilerbau.phases._02_03_parser.Sym;
import de.thm.mni.compilerbau.absyn.Position;
import de.thm.mni.compilerbau.table.Identifier;
import de.thm.mni.compilerbau.CommandLineOptions;
import java_cup.runtime.*;

%%


%class Scanner
%public
%line
%column
%cup

L       = [A-Za-z_]
D       = [0-9]
H       = [0-9A-Fa-f]
ID      = {L} ({L}|{D})*
DECNUM  = {D}+
HEXNUM  = 0x{H}+

%eofval{
    return new java_cup.runtime.Symbol(Sym.EOF, yyline + 1, yycolumn + 1);   //This needs to be specified when using a custom sym class name
%eofval}

%{
    public CommandLineOptions options = null;
  
    private Symbol symbol(int type) {
      return new Symbol(type, yyline + 1, yycolumn + 1);
    }

    private Symbol symbol(int type, Object value) {
      return new Symbol(type, yyline + 1, yycolumn + 1, value);
    }
%}

%%

// TODO (assignment 1): The regular expressions for all tokens need to be defined here.

[ \t\n\r] { /* fuer SPACE, TAB und NEWLINE ist nichts zu tun */ }
\/\/.*$ { /* Kommentare werden ignoriert bis Zeilenende */ }
// { /* f¨ur SPACE, TAB und NEWLINE ist nichts zu tun */ }

else { return symbol(Sym.ELSE); }
while { return symbol(Sym.WHILE); }
ref { return symbol(Sym.REF); }
if { return symbol(Sym.IF); }
of { return symbol(Sym.OF); }
type { return symbol(Sym.TYPE); }
proc { return symbol(Sym.PROC); }
array { return symbol(Sym.ARRAY); }
var { return symbol(Sym.VAR); }

\+ { return symbol(Sym.PLUS); }
\- { return symbol(Sym.MINUS); }
\* { return symbol(Sym.STAR); }
\/ { return symbol(Sym.SLASH); }
\= { return symbol(Sym.EQ); }
\:= { return symbol(Sym.ASGN); }
\< { return symbol(Sym.LT); }
\> { return symbol(Sym.GT); }
\<\= { return symbol(Sym.LE); }
\>\= { return symbol(Sym.GE); }

\{ {return symbol(Sym.LCURL);}
\} {return symbol(Sym.RCURL);}
\( {return symbol(Sym.LPAREN);}
\) {return symbol(Sym.RPAREN);}
\: {return symbol(Sym.COLON);}
\; {return symbol(Sym.SEMIC);}
\, {return symbol(Sym.COMMA);}
\[ {return symbol(Sym.LBRACK);}
\] {return symbol(Sym.RBRACK);}
\# {return symbol(Sym.NE);}

{DECNUM} {return symbol(Sym.INTLIT, Integer.parseInt(yytext()));}
{HEXNUM} {return symbol(Sym.INTLIT, Integer.parseInt(yytext().substring(2), 16));}
'.' {return symbol(Sym.INTLIT, (int)yytext().charAt(1));}
'\\n' {return symbol(Sym.INTLIT, 10);}
{ID} {return symbol(Sym.IDENT, new Identifier(yytext()));}

' {throw SplError.IllegalApostrophe(new Position(yyline + 1, yycolumn + 1));}
[^] {throw SplError.IllegalCharacter(new Position(yyline + 1, yycolumn + 1), yytext().charAt(0));}
//. {/* catch-all-action */ return symbol(Sym.error);}
