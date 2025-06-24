extends CharacterBody2D
class_name EnemigoBase

@export var speed := 40
@export var chase_speed := 80
@export var vision_radius := 100.0

var direction := Vector2.ZERO
var jugador_en_rango := false
var jugador: Node2D = null

@onready var timer := $DirectionTimer
@onready var vision := $Vision

func _ready():
	configurar_vision()
	timer.timeout.connect(cambiar_direccion)
	vision.body_entered.connect(_on_body_entered)
	vision.body_exited.connect(_on_body_exited)

	cambiar_direccion()
	timer.start()

func _physics_process(delta):
	if jugador_en_rango and jugador:
		var direccion_al_jugador = (jugador.global_position - global_position).normalized()
		# INVERSO: se aleja — esto lo CORREGIMOS
		velocity = -direccion_al_jugador * chase_speed

	else:
		velocity = direction * speed

	move_and_slide()

func cambiar_direccion():
	if jugador_en_rango:
		return
	var direcciones = [
		Vector2.UP,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.RIGHT,
		Vector2.ZERO
	]
	direction = direcciones[randi() % direcciones.size()]
	timer.start(randf_range(1.5, 3.0))

func configurar_vision():
	var shape = CircleShape2D.new()
	shape.radius = vision_radius
	$Vision/CollisionShape2D.shape = shape

func _on_body_entered(body):
	print("Entró al área de visión:", body.name)
	if body is CharacterBody2D:
		print("¡Jugador detectado!")
		jugador_en_rango = true
		jugador = body


func _on_body_exited(body):
	if body.is_in_group("jugador"):
		jugador_en_rango = false
		jugador = null
