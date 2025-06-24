extends CharacterBody2D

var jugador: Node2D = null
@export var vel: float = 80.0

var vida_max := 100
var vida := vida_max

var retroceso_duracion := 0.4
var retroceso_velocidad := 300.0
var en_retroceso := false
	

func _physics_process(delta: float) -> void:
	if en_retroceso:
		move_and_slide()
		return

	$AnimatedSprite2D.play("move")

	if jugador != null:
		var direccion = position.direction_to(jugador.position)
		var distancia = position.distance_to(jugador.position)

		if distancia > 10:
			velocity = direccion * vel
		else:
			velocity = Vector2.ZERO
	else:
		velocity = Vector2.ZERO

	# Aquí se usa move_and_collide en lugar de move_and_slide
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = Vector2.ZERO

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body != self:
		jugador = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body == jugador:
		jugador = null

func recibir_danio(cantidad: int):
	vida -= cantidad
	print("Enemigo recibió daño. Vida restante: ", vida)

	if jugador != null:
		var direccion_retroceso = (position - jugador.position).normalized()
		aplicar_retroceso(direccion_retroceso)

	if vida <= 0:
		morir()

func aplicar_retroceso(direccion: Vector2):
	en_retroceso = true
	velocity = direccion * retroceso_velocidad

	# Después de un corto tiempo, deja de retroceder
	await get_tree().create_timer(retroceso_duracion).timeout
	en_retroceso = false

func morir():
	print("¡El enemigo ha muerto!")
	queue_free()
