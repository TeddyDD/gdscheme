
extends Reference
	
func tokenize(program):
	var p
	p = program.replace("(", " ( ").replace(")", " ) ").split(" ",false)
	return Array(p)

func array_append_empty(array):
	if array == null:
		array = []
	array.resize(array.size() + 1)
	array[-1] = []

func atom(token):
	if token.is_valid_float() or token.is_valid_integer():
		return token.to_float()
	else:
		return token
		

