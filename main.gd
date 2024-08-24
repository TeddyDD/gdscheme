extends Control

@onready var lisp = Lisp.new()
@onready var env = lisp.global_env

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var l = Lisp.new()
	#var program = "(begin (define r 10) (* pi (* r r)))"
	#print(l.eval(l.parse(program)))
	env.update("print", stdout)
	%Input.grab_focus()

func  stdout(x):
	%Output.text = %Output.text + "\n" + lisp.schemestr(x)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_text_submitted(new_text: String) -> void:
	var res = lisp.eval(lisp.parse(new_text), lisp.global_env)
	stdout(res)
	%Input.clear()
