
extends Reference
	
func tokenize(program):
	var p
	p = program.replace("(", " ( ").replace(")", " ) ").split(" ",false)
	return Array(p)

func read_from_tokens(tokens):
	var prev_stack = []
	var current = []
	
	for t in tokens:
		if t == "(":
			array_append_empty(current)
			prev_stack.append(current)
			current = current[-1] # current is reference to last element of current
		elif t == ")":
			current = prev_stack[-1]
			prev_stack.pop_back()
		else:
			current.append(atom(t))
	if current.empty():
		return current
	else:
		assert(current.size()==1)
		return current[0]

func array_append_empty(array):
	if array == null:
		array = []
	array.resize(array.size() + 1)
	array[-1] = []

func atom(token):
	if token.is_valid_integer():
		return token.to_int()
	elif token.is_valid_float():
		return token.to_float()
	else:
		return token
		

