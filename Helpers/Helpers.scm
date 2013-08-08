;;;This file contains all helper functions available to use

;Initial header and ending, will change once farther along
(define Print-Heading
  (lambda ()
    (printf ".globl _App_9_Entry\n")
    (printf "_App_9_Entry:\n")))

(define Print-Ending
  (lambda ()
    (printf "ret\n")))