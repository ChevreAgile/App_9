;Currently this thing REALLY sucks. It's better than nothing, but it doesn't yet support the binding of variables
;from the pattern expressions to the application expressions
;
;
;Here's some examples of how it works

;Example 1: It finds 5 and returns the right hand side value
;> (eMatch 5
;          (7 8)
;          (3 4)
;          (5 6))
;=> 6

;Example 2: It finds (lambda (x y z) z) and returns the right hand side value
;> (eMatch (lambda (x y z) z)
;        (7 8)
;        ((lambda (x y z) z) 4)
;        (5 6))
;=> 4

;Example 3: It cannot find a match with (lambda (x y z) z) so it returns an error
;> (eMatch (lambda (x y z) z)
;          ((lambda (z) z) 5)
;          ((lambda (x) x) 6)
;          ((lambda (y) y) 7))
;Exception in eMatch: Sooo... You, uh, you messed up something... No match man...

;Example 4: It cannot find a match, but it sees an else statement at the end, so it defaults to that value
;> (eMatch (lambda (x y z) z)
;          ((lambda (z) z) 5)
;          ((lambda (x) x) 6)
;          ((lambda (y) y) 7)
;          (else 8))
;=> 8

;Example 5: '+++' is the symbol for continuing the list, so if the list contains +++ it assumes you don't
;           care about whatever else is in the list
;> (eMatch (lambda (x y z) z)
;          ((lambda (z) z) 5)
;          ((lambda (x +++) z) 6)
;          ((lambda (y) y) 7)
;          (else 8))
;=> 6


(define-syntax eMatch
  (syntax-rules (req else)
    [(_ expr)
     (error 'eMatch "Sooo... You, uh, you messed up something... No match man...")]
    [(_ expr (else e0 e1 ...))
     (begin e0 e1 ...)]
    [(_ expr (else e0))
     e0]
    [(_ expr (p0 (req cl ...) f ...) cont ...)
     (if (and cl ...)
         (eMatch-H expr p0 (begin f ...) (eMatch expr cont ...))
         (eMatch expr cont ...))]
    [(_ expr (p0 f ...) e1 ...)
     (eMatch-H expr p0 (begin f ...) (eMatch expr e1 ...))]
    [(_ e ...)
     (error 'eMatch "Wow, there are so many different ways you could succeed. And yet you fail...")]))

(define-syntax eMatch-H
  (syntax-rules (quote +++)
    [(_ e0 (+++ p0 ...) f cont)
     #t]
    [(_ (e0) (p0) f cont)
     (let ((return (Check e0 p0)))
       (if (equal? (quote e0) return)
           f
           cont))]
    [(_ ((e0 ...) e1 ...) ((p0 ...) p1 ...) f cont)
     (if (eMatch-H (e0 ...) (p0 ...) f #f)
         (eMatch-H (e1 ...) (p1 ...) f cont)
         cont)]
    [(_ (e0 e1 ...) (p0 p1 ...) f cont)
     (let ((return (Check e0 p0)))
       (if (equal? (quote e0) return)
           (eMatch-H (e1 ...) (p1 ...) f cont)
           cont))]
    [(_ (e0 e1 ...) (+++ p1 ...) f cont)
     f]
    [(_ e0 p0 f cont)
     (let ((return (Check e0 p0)))
       (if (equal? (quote e0) return)
           f
           cont))]
    [(_ e ...)
     (error 'eMatch-H "Well, this is clearly wrong...")]))

(define-syntax Check
  (syntax-rules (unquote quote +++)
    [(_ (e) (p))
     (list (Check e p))]
    [(_ e (unquote p))
     (quote e)]
    [(_ e p)
     (if (equal? (quote e) (quote p))
         (quote e)
         #f)]
    [(_ e ...)
     (error 'Check "You idiot, you literally had one job. One job. Just one...")]))