extends "res://gut.gd".Test

var interpeter = preload("res://interpreter.gd")
var env = preload("res://env.gd")

var i = null
var e = null


func setup():
	i = interpeter.new()
	e = env.new().standard_env()
	
func teardown():
	i = null
	e = null

func test_eval_int():
	gut.assert_eq(i.eval(i.parse("(1)"),e), 1, "(1) should eval to 1")
	gut.assert_eq(i.eval(i.parse("(2.0)"),e), 2.0, "(2.0) should eval to 2.0")
	
func test_const_symbol():
	gut.assert_eq(i.eval(i.parse("(pi)"), e), 3.14, "(pi) should eval to 3.14")
	
func test_define_variable():
	i.eval(i.parse("(define x 1)"), e)
	gut.assert_eq(i.eval(i.parse("(x)"), e), 1, "x variable defined to 1")
	i.eval(i.parse("(define y 5.2)"), e)
	gut.assert_eq(i.eval(i.parse("(y)"), e), 5.2, "y variable defined to 5.2")

#func test_eval_program():
#	var program = "(define r 10.0)"
#	var program2 = "(* pi (* r r))"
#	gut.assert_eq( i.eval(i.parse(program), e), str(314.0) ) 