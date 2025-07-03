	  
# script de mi Bolita (Bolita.gd) - MEJORADO
extends Area2D

@export var velocidad: float = 200.0
var direccion: Vector2 = Vector2.ZERO

func iniciar(posicion_inicial: Vector2, direccion_disparo: Vector2):
	global_position = posicion_inicial
	direccion = direccion_disparo
	show() 
	set_physics_process(true)
	print("🚀 ¡Bolita disparada desde:", global_position, " hacia:", direccion, "!")

func _ready():
	#if has_node("Sprite2D"):
		#$Sprite2D.modulate = Color.red
		#$Sprite2D.scale = Vector2(2, 2)
	set_physics_process(false)
	hide()
	print("👻 Bolita plantilla creada (esperando activación).")


func _physics_process(delta):
	position += direccion * velocidad * delta

func _on_area_entered(area):
	pass
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body.recibir_danio(10)
		queue_free()

	elif body.is_in_group("escudo"):
		print("🛡 La bolita chocó con el escudo")
		queue_free()  # Destruye la bolita al impactar el escudo
