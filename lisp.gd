class_name Lisp
extends RefCounted

var global_env = standard_env()

func run(program: String):
	return eval(parse(program))

func parse(program: String):
	return read_from_tokens(tokenize(program))

func tokenize(program: String) -> Array:
	var res: Array = program.\
		replace("\t", "").\
		replace("\n", "").\
		replace("(", " ( ").\
		replace(")", " ) ").split(" ", false)	
	return res

var depth := -1

func eval(x, env:Env=global_env):
	depth += 1
	print(" ".repeat(depth * 2), "-> eval: ", schemestr(x))
	var res = eval_impl(x, env)
	print(" ".repeat(depth * 2), "<- ", schemestr(res))
	depth -= 1
	return res
	
func eval_impl(x, env:Env=global_env):
	if x is String:
		return env.find(x)
	if x is float or x is int:
		return x
	match x:
		["quote", ..]:
			return x[1]
		["lambda", var params, var body]:
			return Proc.new(params, body, env, eval)
		["if", var test, var consq, var alt]:
			var exp = consq if eval(test, env) else alt
			return eval(exp, env)
		["define", var symbol, var exp]:
			env.update(symbol, eval(exp, env))
			return
		['halt', var body]:
			breakpoint
			return eval(body, env)
	var proc = eval(x[0], env)
	var args := []
	for i in range(1, len(x)):
		args.append(eval(x[i], env))
	var res = apply(proc, args)
	return res

func apply(proc, args):
	if proc is Callable:
		return proc.call(args)
	elif proc is Proc:
		return proc.run(args)

func read_from_tokens(tokens: Array) -> Array:
	var prev_stack = []
	var current = []
	
	for t in tokens:
		match t:
			"(":
				current.append([])
				prev_stack.append(current)
				# current is reference to last element of current
				current = current[-1]
			")":
				current = prev_stack[-1]
				prev_stack.pop_back()
			_:
				current.append(atom(t))

	if current.is_empty():
		return current
	else:
		assert(current.size()==1)
		return current[0]

func atom(token):
	if token.is_valid_int():
		return token.to_int()
	elif token.is_valid_float():
		return token.to_float()
	else:
		return token

class Proc:
	var body
	var params: Array
	var env: Env
	var eval: Callable
	func _init(params, body, env, eval) -> void:
		self.body = body
		self.params = params
		self.env = env
		self.eval = eval
	func _to_string() -> String:
		return "<proc %s>" % [params]
	func run(args):
		var newEnv := Env.new()
		newEnv.outer = self.env
		newEnv.add_params(self.params, args)
		return eval.call(body, newEnv)

class Env:
	var content := {}
	var outer: Env
	func _init(from:Dictionary = {}, outer=null, params=[], args=[]):
		self.content = from
		self.outer = outer
		self.add_params(params, args)
	func add_params(params: Array, args: Array) -> void:
		for i in range(params.size()):
			update(params[i], args[i])
	func update(k,v):
		content[k] = v
	func find(v):
		return self.content[v] if content.has(v) else outer.find(v) 

func rest(a: Array) -> Array:
	return a.slice(1, len(a))

func standard_env() -> Env:
	var env = {
		"begin": func(x): return x[-1],
		"pi": PI,
		"null?": func(x): return x == [],
		"first": func(x): return x[0][0],
		"rest": func(x): return rest(x[0]),
		"list": _list,
		"apply": func(x): return apply(x[0], x[1]),
		"equal?": func(x): return _equal(x[0], x[1]),
		"=": func(x): return _equal(x[0], x[1]),
		"map": func(x): return _map(x[0], x[1]),
		"cons": func(x): return _cons(x[0], x[1]),
		"+":  func(x): return x.reduce(_sum),
		"-": func(x): return x.reduce(func(a,x): return a-x),
		"*": func(x): return x.reduce(func(a,x): return a*x),
		"/": func(x): return x.reduce(func(a,x): return a/x),
		">": func(x): return x[0] > x[1],
		"<": func(x): return x[0] < x[1],
		">=": func(x): return x[0] >= x[1],
		"<=": func(x): return x[0] <= x[1],
	}
	return Env.new(env)

func _cons(x,y):
	var res = [x]
	for i in y:
		res.append(i)
	return res

func _map(fn, list):
	return list.map(func(elm): return apply(fn, [elm]))

func _sum(accum, number):
	#if accum == null:
		#return number
	return accum + number

func _equal(a,b) -> bool:
	return typeof(a) == typeof(b) and a == b

func _list(x):
	var r = []
	r.append_array(x)
	return r

func schemestr(x):
	match typeof(x):
		TYPE_ARRAY:
			var b := (x as Array).duplicate(true)
			return "(" + " ".join(b.map(schemestr)) + ")"
		_:
			return str(x)
