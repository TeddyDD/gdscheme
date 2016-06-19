extends "res://gut.gd".Test

var interpeter = preload("res://interpreter.gd")

var i = null

func setup():
	i = interpeter.new()
	
func teardown():
	i = null
	
func test_parse_program():
	var program = "(begin (define r 10) (* pi (* r r)))"
	var result = ['begin', ['define', 'r', 10], ['*', 'pi', ['*', 'r', 'r']]]
	gut.assert_eq(i.parse(program), result)