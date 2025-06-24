extends Node2D

func _ready():
	$Jugador.vida_actualizada.connect($HUD.mostrar_vida)
