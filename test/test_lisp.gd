extends GutTest

var l: Lisp


func before_each():
	l = Lisp.new()


func test_math():
	assert_eq(l.run("(+ 1 2)"), 3)
	assert_eq(l.run("(* 3 4)"), 12)
	assert_eq(l.run("(/ 12 2)"), 6)
	assert_eq(l.run("(< 1 2)"), true)
	assert_eq(l.run("(> 1 2)"), false)
	assert_eq(l.run("(<= 1 1)"), true)
	assert_eq(l.run("(>= 1 2)"), false)


func test_radius():
	var r = l.run("(begin (define r 10) (* pi (* r r)))")
	assert_eq(r, 314.1592653589793)


func test_circle_area():
	l.run("(define circle-area (lambda (r) (* pi (* r r))))")
	var r = l.run("(circle-area (+ 5 5))")
	assert_typeof(r, TYPE_FLOAT)
	var e = 314.159265358979
	assert_almost_eq(r, e, 0.001)


func test_factorial():
	l.run("(define fact (lambda (n) (if (<= n 1) 1 (* n (fact (- n 1))))))")
	assert_eq(l.run("(fact 10)"), 3628800)


func test_first_rest():
	l.run("(define a (list 1 2 3))")
	assert_eq(l.run("(first a)"), 1, "first of list should be 1")
	assert_eq(l.run("(rest a)"), [2, 3], "rest should be 2 3")


func test_equal():
	assert_eq(l.run("(equal? 0 0 )"), true)
	assert_eq(l.run("(equal? 0 1 )"), false)
	assert_eq(l.run("(equal? 3.0 3 )"), false)


func test_count():
	(
		l
		. run(
			"""
(define count 
  (lambda (item L) 
	(if L 
	  (+ (if (equal? item (first L)) 
		   1
		   0)
		 (count item (rest L)))
	  0)))
	"""
		)
	)
	assert_eq(l.run("(count 0 (list 0 1 2 3 0 0))"), 3)
	assert_eq(l.run("(count (quote the) (quote (the more the merrier the bigger the better)))"), 4)


func test_map():
	assert_eq(l.run("(map (lambda (x) (* x 2)) (list 1 2 3))"), [2, 4, 6])


func test_twice_repeat():
	(
		l
		. run(
			"""
(begin
  (define twice (lambda (x) (* 2 x)))
  (define repeat (lambda (f) (lambda (x) (f (f x))))))
	"""
		)
	)
	assert_eq(l.run("(twice 5)"), 10)
	assert_eq(l.run("((repeat twice) 10)"), 40)
	assert_eq(l.run("((repeat (repeat (repeat (repeat twice)))) 10)"), 655360)


func test_cons():
	assert_eq(l.run("(cons 1 (quote ()))"), [1])
	assert_eq(l.run("(cons 1 (cons 2 (cons 3 (quote ()))))"), [1, 2, 3])


func test_fib_map_range():
	(
		l
		. run(
			"""
	(define fib (lambda (n) (if (< n 2) 1 (+ (fib (- n 1)) (fib (- n 2))))))
	"""
		)
	)
	(
		l
		. run(
			"""
	(define range (lambda (a b) (if (= a b) (quote ()) (cons a (range (+ a 1) b)))))
	"""
		)
	)
	assert_eq(l.run("(range 0 5)"), [0, 1, 2, 3, 4])
	assert_eq(l.run("(map fib (range 0 10))"), [1, 1, 2, 3, 5, 8, 13, 21, 34, 55])
