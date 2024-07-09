
(define-syntax test
  (syntax-rules ()
    ((_ name e-actual e-expected)
     (time (begin
             (printf "Testing ~s: " name)
             (let ((actual e-actual) (expected e-expected))
               (if (equal? actual expected)
                 (printf "~s\n" 'success)
                 (begin
                   (printf "FAILURE\nEXPECTED: ~s\nACTUAL: ~s\n"
                           expected actual)
                   (exit 1)))))))))

(include "unify-tests.rkt")
(include "disunify-tests.rkt")
(include "symbolo-tests.rkt")
(include "stringo-tests.rkt")
(include "numbero-tests.rkt")
(include "symbolo-numbero-tests.rkt")
(include "not-stringo-tests.rkt")
(include "not-numbero-tests.rkt")
(include "not-symbolo-tests.rkt")
(include "not-symbolo-not-numbero-tests.rkt")
(include "distype-diseq-tests.rkt")

(include "evalo-tests.rkt")

(display "\nRunning remaining tests")
(newline)

(test 'long-test-0
  (run* (a b c d) (== a (cons b c)) (symbolo b) (=/= a d) (=/= b d) (== c (cons d b)))
  '(#s(Ans ((_.0 . (_.1 . _.0)) _.0 (_.1 . _.0) _.1) ((=/= ((_.0 _.1))) (sym _.0)))))

(include "appendo-tests.rkt")

(include "color-choices-tests.rkt")
(include "relarith-tests.rkt")
