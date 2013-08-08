;;;The current driver of the compiler



;Loading up the helper files

(load "./../Helpers/eMatch.scm")
(load "./../Helpers/Helpers.scm")


;Running the driver

(define (Compile program)
  (with-output-to-file "Assembly.s"
    (lambda ()
      (Print-Heading)
      (Print-Ending))))

