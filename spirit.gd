extends CharacterBody2D

var jugador: Node2D = null
@export var vel: float = 80.0

var vida_max := 100
var vida := vida_max
var parry := false

var retroceso_duracion := 0.5
var retroceso_velocidadSword := 100.0
var retroceso_velocidadShield := 350.0
var en_retroceso := false
var puede_causar_danio_contacto := true
@export var cooldown_danio_contacto_tiempo := 2.0

func _physics_process(delta: float) -> void:
	if en_retroceso:
		move_and_slide()
		return

	if jugador != null:
		var direccion = position.direction_to(jugador.position)
		var distancia = position.distance_to(jugador.position)

		if distancia > 10:
			velocity = direccion * vel
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	move_and_slide()

	# Revisar colisiones y hacer daño si toca al jugador
	for i in range(get_slide_collision_count()):
		var col = get_slide_collision(i)
		if col.get_collider() and col.get_collider().is_in_group("jugador") and puede_causar_danio_contacto:
			col.get_collider().recibir_danio(10)
			iniciar_cooldown_danio_contacto()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		jugador = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	pass

func iniciar_cooldown_danio_contacto():
	puede_causar_danio_contacto = false
	await get_tree().create_timer(cooldown_danio_contacto_tiempo).timeout
	puede_causar_danio_contacto = true

func recibir_danio(cantidad: int):
	vida -= cantidad
	print("Enemigo recibió daño. Vida restante: ", vida)

	if jugador != null:
		var direccion_retroceso = (position - jugador.position).normalized()
		aplicar_retrocesosword(direccion_retroceso)

	if vida <= 0:
		morir()

func aplicar_retrocesosword(direccion: Vector2):
	en_retroceso = true
	velocity = direccion * retroceso_velocidadSword
	await get_tree().create_timer(retroceso_duracion).timeout
	en_retroceso = false

func aplicar_retrocesoshield(direccion: Vector2):
	en_retroceso = true
	velocity = direccion * retroceso_velocidadShield
	await get_tree().create_timer(retroceso_duracion).timeout
	en_retroceso = false
	
func esta_haciendo_parry():
	return parry

func recibir_parry():
	if jugador!=null:
		var direction_retroceso = (position - jugador.position).normalized()
		print("parry recibido")
		aplicar_retrocesoshield(direction_retroceso)
		

func morir():
	print("¡El enemigo ha muerto!")
	queue_free()
