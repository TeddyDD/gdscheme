
extends Reference
	
func tokenize(program):
	var p
	p = program.replace("(", " ( ").replace(")", " ) ").split(" ",false)
	return Array(p)


