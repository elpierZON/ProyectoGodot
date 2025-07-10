extends Control

func _ready():
	$Musictheme.play()
	$VBoxContainer/IniciarJuego.pressed.connect(_on_boton_iniciar_pressed)
	$VBoxContainer/Salir.pressed.connect(_on_boton_salir_pressed)

func _on_boton_iniciar_pressed():
	get_tree().change_scene_to_file("res://main.tscn")  # ← Tu escena principal

func _on_boton_salir_pressed():
	get_tree().quit()
