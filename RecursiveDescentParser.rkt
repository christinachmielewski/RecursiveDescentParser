#lang racket

(require (only-in (file "lex.rkt") lex))

(define tokens (make-parameter null))

(define (parse code)
  (parameterize ([tokens (lex code)])
    (parse-program)))

; program:= exprList
(define (parse-program)
  (print "reached program")
  (list 'program
        (parse-exprList)))

; exprList := expr optExprList
(define (parse-exprList)
  (print "reached parse-exprList")
  (list 'exprList
        (parse-expr)
         (parse-optExprList)))

; optExprList := empty | exprList
(define (parse-optExprList)
  (print "reached parse-optExprList")
  (if (exprList-pending?)
  (list 'optExprList (parse-exprList))
  (list 'optExprList)))

(define (exprList-pending?)
  (or (check 'INT)
      (check 'FLOAT)
      (check 'NAME)
      (check 'STRING)
      (check 'OPAREN)))

; expr := atom | invocation
(define (parse-expr)
  (print "reached parse-expr")
  (list 'expr
  (if(check 'OPAREN)
     (parse-invocation)
     (parse-atom))))
 
; atom := NAME|STRING|number  
(define (parse-atom)
  (print "reached parse-atom")
  (list 'atom
  (if (check 'NAME)
      (consume 'NAME)
      (if(check 'STRING)
         (consume 'STRING)
         (parse-number)))))

; number := INT|FLOAT     
(define (parse-number)
  (print "reached parse-number")
  (if(check 'INT)
     (list 'number (consume 'INT))
     (list 'number (consume 'FLOAT))))

; invocation := OPAREN exprList CPAREN   
(define (parse-invocation)
  (print "reached parse-invocation")
  (list 'invocation
        (consume 'OPAREN)
        (parse-exprList)
        (consume 'CPAREN)))

(define (check type)
  (print "reached check")
  (if (empty? (tokens))
      #f
      (equal? type(first(first(tokens))))))

(define (consume type)
  (print "reached consume")
  (when (empty? (tokens))
    (error (~a "expected token of type " type " but no remaining tokens")))
  (let ([token (first (tokens))])
    (when (not (equal? type (first token)))
      (error (~a "expected token of type " type " but actual token was " token)))
    (tokens (rest (tokens)))  ; update tokens: remove first token
    token))
