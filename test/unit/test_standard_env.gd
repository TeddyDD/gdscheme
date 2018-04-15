extends "res://addons/gut/test.gd"

var env = preload("res://env.gd")
var e = null

func setup():
	e = env.new().standard_env()
	
func teardown():
	e = null
	
func test_math():
	var result =  e["abs"].call_func([-1])
	assert_eq(result, 1)
	
func test_car_cdr():
	var array = [1,2,3]
	assert_eq(e["car"].call_func(array),[1])