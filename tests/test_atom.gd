extends "res://gut.gd".Test

var interpeter = preload("res://interpreter.gd")

var i = null

func setup():
	i = interpeter.new()
	
func teardown():
	i = null
	
func test_symbol():
	gut.assert_eq(i.atom("test"), "test", "Symbol should be string")
	
func test_integer():
	gut.assert_eq(i.atom("1"), 1, "Integer token should return number")
	gut.assert_eq(typeof(i.atom("1")), TYPE_INT, "Integer shoult return int type")

func test_float():
	gut.assert_eq(i.atom("1.5"), 1.5, "Float token shoul return float")
	gut.assert_eq(str(i.atom("1.5")), "1.5")
