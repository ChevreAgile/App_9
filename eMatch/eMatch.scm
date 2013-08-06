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
     (error 'Check "You idiot, you literally had one job. One job. Just one...\n Seriously though, you shouldn't even be able to get this error message. What the shit...")]))
