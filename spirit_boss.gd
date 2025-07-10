extends Spirit

@export var escena_bolita: PackedScene
@export var ataque_cooldown: float = 3.0

var ataques_activos: bool = false
#var en_furia: bool = false

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if jugador == null:
			jugador = get_tree().get_nodes_in_group("jugador")[0]
		disparar_bolita()

func _ready():
	vida = 900
	vel = 100
	vida_max = vida
	if not escena_bolita:
		push_error("¡ERROR: La 'Escena Bolita' no está asignada en el Inspector para el SpiritBoss!")

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if ataques_activos:
			return
		jugador = body
		print("✅ Jugador detectado. ¡Iniciando secuencia de ataque!")
		# Cambiar música
		var main = get_tree().current_scene
		if main.has_node("MusicaFondo") and main.has_node("MusicaBoss"):
			main.get_node("MusicaFondo").stop()
			main.get_node("MusicaBoss").play()
		
		iniciar_secuencia_ataque()

func _on_detection_area_body_exited(body: Node2D) -> void:
	pass

func iniciar_secuencia_ataque():
	ataques_activos = true
	
	while ataques_activos and is_instance_valid(jugador):
		disparar_bolita()
		await get_tree().create_timer(ataque_cooldown).timeout

func disparar_bolita():
	if not escena_bolita: 
		print("❌ escena_bolita no está asignada.")
		return

	var bolita_instance = escena_bolita.instantiate()
	print("✅ Bolita instanciada")
	get_tree().current_scene.add_child(bolita_instance)

	var direccion_hacia_jugador = (jugador.global_position - self.global_position).normalized()
	bolita_instance.iniciar(self.global_position, direccion_hacia_jugador)


func recibir_danio(cantidad: int):
	super.recibir_danio(cantidad)
	if not en_furia and vida <= vida_max / 2:
		activar_furia()

func activar_furia():
	if not en_furia:
		en_furia = true
		vel *= 1.5
		ataque_cooldown /= 2 
		#print("Boss en modo furia! Cooldown reducido a:", ataque_cooldown)
		$AnimatedSprite2D.modulate = Color(1, 0.5, 0.5)  
		
func _physics_process(delta):
	super._physics_process(delta)
