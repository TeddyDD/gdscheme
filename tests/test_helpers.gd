extends "res://gut.gd".Test

var interpeter = preload("res://interpreter.gd")

var i = null

func setup():
	i = interpeter.new()
	
func teardown():
	i = null
	
# Empty array append
func test_empty_array_append():
	gut.assert_ne([ [], [] ], [[]].append([]), "This don't work in Godot")
	
	var e = [[]]
	e.resize(e.size() + 1)
	e[-1] = []
	gut.assert_eq(e,[[],[]], "alternative add empty array")
	
	var f = [[]]
	i.array_append_empty(f)
	gut.assert_eq(f,[[],[]], "custom add array empty method")