
;; Relational arithmetic (list of bits) tests
(display "\nRunning relational arithmetic tests (list of bits)")
(newline)

(include "relarith.rkt")

(test 'test-1
  (run* (q) (*o (build-num 2) (build-num 3) q))
  '(((0 1 1))))

(test 'test-2
  (run* (q)
    (fresh (n m)
      (*o n m (build-num 6))
      (== `(,n ,m) q)))
  '((((1) (0 1 1))) (((0 1 1) (1))) (((0 1) (1 1))) (((1 1) (0 1)))))

(test 'sums
  (run 5 (q)
    (fresh (x y z)
      (pluso x y z)
      (== `(,x ,y ,z) q)))
  '(((_.0 () _.0))
    ((() (_.0 . _.1) (_.0 . _.1)))
    (((1) (1) (0 1)))
    (((1) (0 _.0 . _.1) (1 _.0 . _.1)))
    (((1) (1 1) (0 0 1)))))

(test 'factors
  (run* (q)
    (fresh (x y)
      (*o x y (build-num 24))
      (== `(,x ,y ,(build-num 24)) q)))
  '((((1) (0 0 0 1 1) (0 0 0 1 1)))
    (((0 0 0 1 1) (1) (0 0 0 1 1)))
    (((0 1) (0 0 1 1) (0 0 0 1 1)))
    (((0 0 1) (0 1 1) (0 0 0 1 1)))
    (((0 0 0 1) (1 1) (0 0 0 1 1)))
    (((1 1) (0 0 0 1) (0 0 0 1 1)))
    (((0 1 1) (0 0 1) (0 0 0 1 1)))
    (((0 0 1 1) (0 1) (0 0 0 1 1)))))

(test 'logo-2
  (run 2 (b q r)
    (logo '(0 0 1 0 0 0 1) b q r)
    (>1o q))
  '((() (_.0 _.1 . _.2) (0 0 1 0 0 0 1))
    ((1) (_.0 _.1 . _.2) (1 1 0 0 0 0 1))))

(displayln "\nThe next test might take a minute...")
(test 'logo-9
  (run 9 (b q r)
    (logo '(0 0 1 0 0 0 1) b q r)
    (>1o q))
  '((() (_.0 _.1 . _.2) (0 0 1 0 0 0 1))
    ((1) (_.0 _.1 . _.2) (1 1 0 0 0 0 1))
    ((0 1) (0 1 1) (0 0 1))
    ((1 1) (1 1) (1 0 0 1 0 1))
    ((0 0 1) (1 1) (0 0 1))
    ((0 0 0 1) (0 1) (0 0 1))
    ((1 0 1) (0 1) (1 1 0 1 0 1))
    ((0 1 1) (0 1) (0 0 0 0 0 1))
    ((1 1 1) (0 1) (1 1 0 0 1))))

