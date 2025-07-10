extends Area2D

@export var velocidad: float = 250.0
var direccion: Vector2 = Vector2.ZERO

func iniciar(posicion_inicial: Vector2, direccion_disparo: Vector2):
	global_position = posicion_inicial
	direccion = direccion_disparo.normalized()
	show()
	set_physics_process(true)

func _ready():
	self.body_entered.connect(_on_body_entered)
	self.area_entered.connect(_on_area_entered)
	
	set_physics_process(false)
	hide()
	print("✅ Bolita plantilla creada (esperando activación).")

func _physics_process(delta):
	position += direccion * velocidad * delta

# Detecta colisión con el jugador (CharacterBody2D)
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		print("💥 Bolita impactó al jugador")
		body.recibir_danio(10)
		queue_free()

# Detecta colisión con el escudo (Area2D)
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("escudo"):
		print("🛡️ ¡Bolita destruida por escudo!")
		queue_free()
