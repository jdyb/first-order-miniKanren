
(display "\nRunning struct unification tests")
(newline)

(struct foo (x) #:prefab)
(struct bar (x) #:prefab)
(struct baz (x y) #:prefab)

(test 'struct-0
  (run* (x) (== x (foo 42)))
  '((#s(foo 42))))

(test 'struct-1
  (run* (x) (== (foo 42) (foo x)))
  '((42)))

(test 'struct-2
  (run* () (== (foo 42) (foo 42)))
  '(()))

(test 'struct-3
  (run* () (== (foo 42) (bar 42)))
  '())

(test 'struct-4
  (run* () (== (foo 42) (foo 2)))
  '())

