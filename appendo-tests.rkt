
(define-relation (appendo xs ys xsys)
  (conde ((== xs '()) (== ys xsys))
         ((fresh (x zs zsys)
            (== `(,x . ,zs)   xs)
            (== `(,x . ,zsys) xsys)
            (appendo zs ys zsys)))))

(test 'appendo-0
  (run* (xs ys) (appendo xs ys '(a b c d)))
  '((()        (a b c d))
    ((a)       (b c d))
    ((a b)     (c d))
    ((a b c)   (d))
    ((a b c d) ())))

(test 'appendo-1
  (run* (q) (appendo '(a b c) '(d e) q))
  '(((a b c d e))))

(test 'appendo-2
  (run* (q) (appendo q '(d e) '(a b c d e)))
  '(((a b c))))

(test 'appendo-3
  (run* (q) (appendo '(a b c) q '(a b c d e)))
  '(((d e))))

(test 'appendo-4
  (run 5 (q)
    (fresh (l s out)
      (appendo l s out)
      (== (cons l (cons s (cons out '()))) q)))
  '(((() _.0 _.0)) (((_.0) _.1 (_.0 . _.1)))
  (((_.0 _.1) _.2 (_.0 _.1 . _.2))) 
  (((_.0 _.1 _.2) _.3 (_.0 _.1 _.2 . _.3))) 
  (((_.0 _.1 _.2 _.3) _.4 (_.0 _.1 _.2 _.3 . _.4)))))

