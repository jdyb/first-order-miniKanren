(display "\nRunning (basic) integero tests")
(newline)

(test 'integero-0
  (run* (x) (integero x))
  '(#s(Ans (_.0) ((int _.0)))))

