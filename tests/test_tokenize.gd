extends "res://gut.gd".Test

var interpeter = preload("res://interpreter.gd")

var i = null

func setup():
	i = interpeter.new()
	
func teardown():
	i = null
	
func test_tokenize_string():
	var program = "(begin (define r 10) (* pi (* r r)))"
	var result = ['(', 'begin', '(', 'define', 'r', '10', ')', '(', '*', 'pi', '(', '*', 'r', 'r', ')', ')', ')']
	gut.assert_eq(i.tokenize(program), result)
	
func test_empty():
	gut.assert_eq(i.tokenize(""), [], "Empty program should return empty array")