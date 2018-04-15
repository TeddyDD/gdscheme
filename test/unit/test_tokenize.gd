extends "res://addons/gut/test.gd"

var interpeter = preload("res://interpreter.gd")

var i = null

func setup():
	i = interpeter.new()
	
func teardown():
	i = null
	
func test_tokenize_string():
	var program = "(begin (define r 10) (* pi (* r r)))"
	var result = ['(', 'begin', '(', 'define', 'r', '10', ')', '(', '*', 'pi', '(', '*', 'r', 'r', ')', ')', ')']
	assert_eq(i.tokenize(program), result)
	
func test_empty():
	assert_eq(i.tokenize(""), [], "Empty program should return empty array")