extends Area2D

signal cambiar_mapa(destino: String)

@export var destino := "res://mapas/mapa_aldea.tscn"

func _on_body_entered(body: Node):
	if body.is_in_group("jugador"):
		emit_signal("cambiar_mapa", destino)
