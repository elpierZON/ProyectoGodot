extends Area2D
class_name rupia
@export var destino := "res://mapa_aldea.tscn"


@export var cantidad := 1

func _ready():
	$AnimatedSprite2D.play("rupia") 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		$"../RupiaAudio".play()
		body.agregar_rupias(cantidad)
		queue_free()  # Desaparece


func _on_rupia_2_body_entered(body: Node2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		get_tree().change_scene_to_file(destino)
