extends "res://addons/gut/test.gd"

var interpeter = preload("res://interpreter.gd")
var env = preload("res://env.gd")

var i = null
var e = null

func eval_parse(program):
	return	i.eval(i.parse(program), e)


func setup():
	i = interpeter.new()
	e = env.new().standard_env()
	
func teardown():
	i = null
	e = null

func test_eval_number():
	assert_eq(eval_parse("(1)"), 1, "(1) should eval to 1 (int)")
	assert_eq(eval_parse("(2.0)"), 2.0, "(2.0) should eval to 2.0 (float)")
	
func test_const_symbol():
	assert_eq(eval_parse("(pi)"),  3.14, "(pi) should eval to 3.14")
	
func test_define_variable():
	eval_parse("(define x 1)")
	assert_eq(eval_parse("(x)"),  1, "x variable defined to 1")
	
	eval_parse("(define y 5.2)")
	assert_eq(eval_parse("(y)"),  5.2, "y variable defined to 5.2")
	
	eval_parse("(define mypi pi)")
	#p("Program: (define mypi pi)", 2)
	assert_eq(eval_parse("(mypi)"),  3.14, "define variable from other variable")
	
	eval_parse("(define y 0)")
	assert_eq(eval_parse("(y)"),  0, "redefine variable y")

func test_procedure():
	assert_eq(eval_parse("(+ 1 2)"),  3, "add two numbers")
	assert_eq(eval_parse("(* 3 4)"),  12, "multiply two numbers")
	assert_eq(eval_parse("(+ (* 2 3) 1)"),  7, "2*3 + 7")
	
	assert_eq(eval_parse("(abs -10)"), 10, "abs from 10")
	
func test_eval_program():
	var program = "(define r 10.0)"
	eval_parse(program)
	var program2 = "(* pi (* r r))"
	assert_eq( eval_parse(program2),  314.0 ) 
