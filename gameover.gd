extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	$VBoxContainer/Reintentar.pressed.connect(_on_reintentar_pressed)
	$VBoxContainer/Salir.pressed.connect(_on_salir_pressed)

func _on_reintentar_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")  

func _on_salir_pressed():
	get_tree().quit()
