
;; This is an interpreter for a simple Lisp.  Variables in this language are
;; represented namelessly, using De Bruijn indices.
;; Because it is implemented as a relation, we can run this interpreter with
;; unknowns in any argument position.  If we place unknowns in the `expr`
;; position, we can synthesize programs.
(define-relation (eval-expo expr env value)
  (conde ;; NOTE: this clause order is optimized for quine generation.
    ((fresh (body)
       (== `(lambda ,body) expr)      ;; expr is a procedure definition
       (== `(closure ,body ,env) value)))
    ;; If this is before lambda, quoted closures become likely.
    ((== `(quote ,value) expr))       ;; expr is a literal constant
    ((fresh (a*)
       (== `(list . ,a*) expr)        ;; expr is a list operation
       (eval-listo a* env value)))
    ((fresh (a d va vd)
       (== `(cons ,a ,d) expr)        ;; expr is a cons operation
       (== `(,va . ,vd) value)
       (eval-expo a env va)
       (eval-expo d env vd)))
    ((fresh (index)
       (== `(var ,index) expr)        ;; expr is a variable
       (lookupo index env value)))
    ;((fresh (c va vd)
       ;(== `(car ,c) expr)            ;; expr is a car operation
       ;(== va value)
       ;(eval-expo c env `(,va . ,vd))))
    ;((fresh (c va vd)
       ;(== `(cdr ,c) expr)            ;; expr is a cdr operation
       ;(== vd value)
       ;(eval-expo c env `(,va . ,vd))))
    ((fresh (rator rand arg env^ body)
       (== `(app ,rator ,rand) expr)  ;; expr is a procedure application
       (eval-expo rator env `(closure ,body ,env^))
       (eval-expo rand env arg)
       (eval-expo body `(,arg . ,env^) value)))))

;; Lookup the value a variable is bound to.
;; Variables are represented namelessly using relative De Bruijn indices.
;; These indices are encoded as peano numerals: (), (s), (s s), etc.
(define-relation (lookupo index env value)
  (fresh (arg e*)
    (== `(,arg . ,e*) env)
    (conde
      ((== '() index) (== arg value))
      ((fresh (i* a d)
         (== `(s . ,i*) index)
         (== `(,a . ,d) e*)
         (lookupo i* e* value))))))

;; This helper evaluates arguments to a list construction.
(define-relation (eval-listo e* env value)
  (conde
    ((== '() e*) (== '() value))
    ((fresh (ea ed va vd)
       (== `(,ea . ,ed) e*)
       (== `(,va . ,vd) value)
       (eval-expo ea env va)
       (eval-listo ed env vd)))))

(define (evalo expr value) (eval-expo expr '() value))

(test 'evalo-literal
  (run 1 (e) (evalo e 5))
  '(((quote 5))))
(test 'evalo-quine
  (run 1 (e) (evalo e e))
  '(((app (lambda (list (quote app) (var ())
                        (list (quote quote) (var ()))))
          (quote (lambda (list (quote app) (var ())
                               (list (quote quote) (var ())))))))))

(displayln "\nBeginning slower tests...")
(test 'evalo-twine
  (run 1 (p q) (evalo p q) (evalo q p))
  '(((quote (app (lambda (list (quote quote)
                               (list (quote app) (var ())
                                     (list (quote quote) (var ())))))
                 (quote (lambda (list (quote quote)
                                      (list (quote app) (var ())
                                            (list (quote quote) (var ()))))))))
     (app (lambda (list (quote quote)
                        (list (quote app) (var ())
                              (list (quote quote) (var ())))))
          (quote (lambda (list (quote quote)
                               (list (quote app) (var ())
                                     (list (quote quote) (var ()))))))))))

(displayln "\nThe next test may take many seconds...")
(test 'evalo-thrine
  (run 1 (p q r) (evalo p q) (evalo q r) (evalo r p))
  '(((quote (quote (app (lambda (list (quote quote)
                                      (list (quote quote)
                                            (list (quote app) (var ())
                                                  (list (quote quote) (var ()))))))
                        (quote (lambda (list (quote quote)
                                             (list (quote quote)
                                                   (list (quote app) (var ())
                                                         (list (quote quote) (var ()))))))))))
     (quote (app (lambda (list (quote quote)
                               (list (quote quote)
                                     (list (quote app) (var ())
                                           (list (quote quote) (var ()))))))
                 (quote (lambda (list (quote quote)
                                      (list (quote quote)
                                            (list (quote app) (var ())
                                                  (list (quote quote) (var ())))))))))
     (app (lambda (list (quote quote)
                        (list (quote quote)
                              (list (quote app) (var ())
                                    (list (quote quote) (var ()))))))
          (quote (lambda (list (quote quote)
                               (list (quote quote)
                                     (list (quote app) (var ())
                                           (list (quote quote) (var ())))))))))))

