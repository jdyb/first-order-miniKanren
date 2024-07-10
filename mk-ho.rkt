#lang racket
(provide
  ==
  =/=
  symbolo
  numbero
  integero
  stringo
  not-symbolo
  not-numbero
  not-stringo

  define-relation
  fresh
  conde
  query
  run
  run*

  stream-take
  conj*
  disj*
  )
(require "microk-ho.rkt")
(include "mk-syntax.rkt")
