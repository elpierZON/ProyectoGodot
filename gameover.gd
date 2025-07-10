extends Control

func _ready():
	$VBoxContainer/Reintentar.pressed.connect(_on_reintentar_pressed)
	$VBoxContainer/Salir.pressed.connect(_on_salir_pressed)

func _on_reintentar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_salir_pressed():
	get_tree().quit()
