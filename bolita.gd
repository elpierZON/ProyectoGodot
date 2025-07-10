extends Area2D

@export var velocidad: float = 250.0
var direccion: Vector2 = Vector2.ZERO

func iniciar(posicion_inicial: Vector2, direccion_disparo: Vector2):
	global_position = posicion_inicial
	direccion = direccion_disparo
	show() 
	set_physics_process(true)

func _ready():
	self.body_entered.connect(_on_body_entered)
	set_physics_process(false)
	hide()
	print(" Bolita plantilla creada (esperando activación).")

func _physics_process(delta):
	position += direccion * velocidad * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		body.recibir_danio(10)
		queue_free()
	elif body.is_in_group("escudo"):
		print("🛡️ ¡Bolita destruida por escudo!")
		queue_free()
