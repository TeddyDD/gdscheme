extends Node2D

func _ready():
    # get an instance of gut
    var tester = load('res://gut.gd').new()
    # Move it down some so you can see the dialog box bar at top
    tester.set_pos(Vector2(0,60))
    add_child(tester)

    # stop it from printing to console, just because
    tester.set_should_print_to_console(false)

    # Add all the scripts in a directory
    tester.add_directory('res://tests')

    tester.test_scripts()