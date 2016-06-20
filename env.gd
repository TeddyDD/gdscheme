
extends Node
	
	
func standard_env():
	var env = {
		"abs": funcref(self, "__abs"),
		"car": funcref(self, "__car"),
		"cdr": funcref(self, "__cdr"),
		"+" : funcref(self, "__add"),
		"*" : funcref(self, "__multiply"),
		"pi": 3.14,
	}
	return env
	
func __abs(s):
	return abs(s)
	
func __car(x):
	return [x[0]]

func __cdr(x):
	var r = []
	for i in range(1,x.size()):
		r.apply(i)
	return r
	
func __multiply(x):
	return float(x[0]) * float(x[1])
	
func __add(x):
	return float(x[0]) + float(x[1])
	
