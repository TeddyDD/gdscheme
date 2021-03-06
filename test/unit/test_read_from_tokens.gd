extends "res://addons/gut/test.gd"

var interpeter = preload("res://interpreter.gd")

var i = null

func setup():
	i = interpeter.new()
	
func teardown():
	i = null
	
func test_empty():
	assert_eq(i.read_from_tokens([]), [], "Empty program should return empty array")
	
func test_simple_list():
	var tokens = ["(","test", "1.0", "2.0", "3.0",")"]
	var result = ["test", 1.0, 2.0, 3.0]
	assert_eq(i.read_from_tokens(tokens), result)
	
	
func test_one_symbol_atom():
	var tokens = ["(","test",")"]
	var result = ["test"]
	assert_eq(typeof(i.read_from_tokens(tokens)[0]),TYPE_STRING, "first element should be symbol")
	assert_eq(i.read_from_tokens(tokens), result)
	
	
func test_one_number_atom():
	var tokens = ["(","1",")"]
	var result = [1]
	assert_eq(i.read_from_tokens(tokens), result)
	
func test_empty_nested():
	var tokens = ["(","(",")","(",")",")"]
	var result = [[],[]]
	assert_eq(i.read_from_tokens(tokens).size(), 2, "array should have two elements")
	assert_eq(i.read_from_tokens(tokens),result, "() should create nested array")
	
	assert_eq(typeof(i.read_from_tokens(tokens)[0]),TYPE_ARRAY, "first element should be array")
	assert_eq(typeof(i.read_from_tokens(tokens)[1]),TYPE_ARRAY, "second element should be array")
	
	assert_eq(i.read_from_tokens(tokens)[1].empty(), true, "First array should be empty")
	assert_eq(i.read_from_tokens(tokens)[1].empty(), true, "Second array should be empty")
	
func test_one_level_nested():
	var tokens = ["(","1.0","(","1.0",")",")"]
	var result = [1.0,[1.0]]
	assert_eq(typeof(i.read_from_tokens(tokens)[0]),TYPE_REAL, "first element should be float")
	assert_eq(typeof(i.read_from_tokens(tokens)[1]),TYPE_ARRAY, "second element should be array")
	assert_eq(i.read_from_tokens(tokens),result, "() should create nested array")

func test_simple_nested():
	var tokens = ["(","1","(", "2", ")", "1",")"]
	var result = [1, [2], 1]
	assert_eq(i.read_from_tokens(tokens), result)

func test_nested():
	# program (begin (define r 10) (* pi (* r r)))
	var tokens = ['(', 'begin', '(', 'define', 'r', '10', ')', '(', '*', 'pi', '(', '*', 'r', 'r', ')', ')', ')']
	var result = ['begin', ['define', 'r', 10], ['*', 'pi', ['*', 'r', 'r']]]
	var got = i.read_from_tokens(tokens)
	assert_eq(got, result)