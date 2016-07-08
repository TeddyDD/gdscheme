
extends Reference

onready var env = preload("res://env.gd").new()

func parse(program):
	return read_from_tokens(tokenize(program))

func tokenize(program):
	var p
	p = program.replace("(", " ( ").replace(")", " ) ").split(" ",false)
	return Array(p)

func read_from_tokens(tokens):
	var prev_stack = []
	var current = []
	
	for t in tokens:
		if t == "(":
			current.append([])
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

func atom(token):
	if token.is_valid_integer() and token.is_valid_float():
		return token.to_int()
	elif token.is_valid_float():
		return token.to_float()
	else:
		return token
		

# eval list x in env
func eval(x, env):
	prints("EVAL " , x)
#	assert(typeof(x) == TYPE_ARRAY)
	if typeof(x) == TYPE_ARRAY:
		var head_type = typeof(x[0])
		if head_type == TYPE_INT or head_type == TYPE_REAL:
			return x[0]
		elif head_type == TYPE_STRING and x.size() == 1:      # variable reference
			return env[x[0]]
		elif head_type == TYPE_STRING and x[0] == "define":   # define a variable
			var variable = x[1]
			var expr = eval(x[2], env)
			env[variable] = expr
		elif head_type == TYPE_STRING:
			var proc = eval(x[0], env)
			var args = []
			for arg in range(1, x.size()):
				args.append(eval(x[arg],env))
			return proc.call_func(args)
	else:
		if typeof(x) == TYPE_STRING:
			return env[x]
		elif typeof(x) == TYPE_REAL or typeof(x) == TYPE_INT:
			return x
