extends Node2D

var mapa_actual: Node = null
var jugador_ha_muerto := false


func _ready():
	$Jugador.conectar_hud($HUD)  
	$Jugador.vida_actualizada.connect($HUD.actualizar_vida)  
	$Jugador.actualizar_vida_visual() 

	cargar_mapa("res://mapas/mapa_aldea.tscn") 

func cargar_mapa(path: String, spawn_name := "SpawnJugador"):
	if mapa_actual:
		mapa_actual.queue_free()
	mapa_actual = load(path).instantiate()
	$ContenedorMapa.add_child(mapa_actual)

	var spawn = mapa_actual.get_node_or_null(spawn_name)
	if spawn:
		$Jugador.global_position = spawn.global_position
	else:
		print("No se encontró 'SpawnJugador'. Usando (0,0).")
		$Jugador.global_position = Vector2.ZERO

	var puerta_1 = mapa_actual.get_node_or_null("PuertaMapa01")
	if puerta_1:
		puerta_1.body_entered.connect(_on_puerta_body_entered)

	var puerta_retorno = mapa_actual.get_node_or_null("Retorno")
	if puerta_retorno:
		puerta_retorno.body_entered.connect(_on_puerta_retorno_body_entered)
	
	var camino_boss = mapa_actual.get_node_or_null("CaminoBoss")
	if camino_boss:
		camino_boss.body_entered.connect(_on_camino_boss_body_entered)

	var retorno_boss = mapa_actual.get_node_or_null("RetornoDesdeMapa01")
	if retorno_boss:
		retorno_boss.body_entered.connect(_on_retorno_desde_boss_body_entered)


func _on_camino_boss_body_entered(body):
	if body.is_in_group("jugador"):
		cambiar_mapa_con_transicion("res://mapas/Mapa_boss.tscn", "SpawnDesdeMapa01")

func _on_retorno_desde_boss_body_entered(body):
	if body.is_in_group("jugador"):
		cambiar_mapa_con_transicion("res://mapas/mapa_01.tscn", "SpawnDesdeMapaBoss")


func _on_puerta_body_entered(body):
	if body.is_in_group("jugador"):
		cambiar_mapa_con_transicion("res://mapas/mapa_01.tscn", "SpawnDesdeAldea")

func cambiar_mapa_con_transicion(path: String, spawn_name := "SpawnJugador") -> void:
	var transicion = $Transicion
	var anim = transicion.get_node("AnimationPlayer")
	anim.play("fade_to_black")
	await anim.animation_finished
	cargar_mapa(path, spawn_name)
	anim.play("fade_to_normal")
	
func _on_puerta_retorno_body_entered(body):
	if body.is_in_group("jugador"):
		cambiar_mapa_con_transicion("res://mapas/mapa_aldea.tscn", "SpawnDesdeMapa01")

func ir_a_game_over():
	var anim = $Transicion.get_node("AnimationPlayer")
	anim.play("fade_to_black")
	await anim.animation_finished

	get_tree().change_scene_to_file("res://GAMEOVER.tscn")
