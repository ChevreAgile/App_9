;Currently this thing REALLY sucks. It's better than nothing, but it is still SUPER slow
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

;Example 5: '***' is the symbol for continuing the list, so if the list contains +++ it assumes you don't
;           care about whatever else is in the list
;> (eMatch (lambda (x y z) z)
;          ((lambda (z) z) 5)
;          ((lambda (x ***) z) 6)
;          ((lambda (y) y) 7)
;          (else 8))
;=> 6

;Example 6: "Wild-card" variables allow you to account for variables with a designation you are not yet aware of
;> (eMatch (lambda (x) 94)
;          ((lambda (x) ,j) 3))
;=> 3

;Example 6: I've added "wild-card" variable binding so that you can use "wild-card" variables from the
;           pattern expression in the successful-match expression
;> (eMatch (lambda (x y z) 98)
;          ((lambda (z) z) 5)
;          ((lambda (x y z) ,a) a)
;          ((lambda (y) y) 7)
;          (else 8))
;=> 98


(define-syntax eMatch
  (syntax-rules (req else quote)
    [(_ expr)
     (error 'eMatch "Sooo... You, uh, you messed up something... No match man...")]
    [(_ expr (else e0 e1 ...))
     (begin e0 e1 ...)]
    [(_ expr (else e0))
     e0]
    [(_ (e0 e1 ...) (p0 (req cl ...) f ...) e ...)
     (let ((cont (lambda () (eMatch (e0 e1 ...) e ...))))
       (if (and cl ...)
           (eMatch-H (e0 e1 ...) p0 (begin f ...) cont)
           cont))]
    [(_ (e0 e1 ...) (p0 f ...) e ...)
     (let ((cont (lambda () (eMatch (e0 e1 ...) e ...))))
       (eMatch-H (e0 e1 ...) p0 (begin f ...) cont))]
    [(_ e ...)
     (error 'eMatch "Wow, there are so many different ways you could succeed. And yet you fail...")]))

(define-syntax eMatch-H
  (syntax-rules (quote *** unquote)
    [(_ (e0 e1 ...) ((unquote p0) *** p1 ...) f cont)
     (let ((p0 (list e0 e1 ...))) f)]
    [(_ (e0 e1 ...) (p0 p1 ...) f cont)
     (if (Valid? (quote e0) (quote p0))
         (if (Match? (quote e0) (quote p0))
             (eMatch-H (e1 ...) (p1 ...) f cont)
             (cont))
         (let ((result (eMatch-H e0 p0 (eMatch-H (e1 ...) (p1 ...) f (lambda () 'M-F)) (lambda () 'M-F))))
           (if (equal? result 'M-F)
               (cont)
               result)))]
    [(_ e0 (unquote p0) f cont)
     (let ((p0 e0)) f)]
    [(_ e0 p0 f cont)
     (if (Match? (quote e0) (quote p0))
         f
         (cont))]))

(define Valid?
  (lambda (x y)
    (not (or (pair? x) (pair? y)))))

(define Match?
  (lambda (x y)
    (equal? x y)))
