
(display "\nRunning vector unification tests")
(newline)

(test 'vector-0
  (run* (x) (== x (vector)))
  '((#())))

(test 'vector-1
  (run* (x) (== (vector 42) (vector x)))
  '((42)))

(test 'vector-2
  (run* () (== (vector) (vector 1)))
  '())

(test 'vector-3
  (run* () (== (vector 1) (vector 2)))
  '())

