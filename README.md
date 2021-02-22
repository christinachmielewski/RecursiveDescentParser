# RecursiveDescentParser
Parser for an LL(1) grammar in Racket.


Parser for LL(1) grammar whose starting rule is "program":
program     := exprList
exprList    := expr optExprList
optExprList := ɛ | exprList
expr        := atom | invocation
atom        := NAME | STRING | number
number      := INT | FLOAT
invocation  := OPAREN exprList CPAREN

Terminal symbols are in all caps, nonterminals are in camelCase.

**Argument** string of code
**Return Value** parse tree

Each node in parse tree is a token corresponding to temrinal symbol or a Racket list containing first the nonterminal symbol
being derived and a parse tree for each of the symbols in the RHS of the derivation.

* If right side of derivation is e, node is a list with a single item which is the nonterminal symbol being derived.
