
extends CanvasLayer

@onready var corazon_lleno: Texture = $ContenedorCorazones/Corazon1.texture
@onready var corazon_vacio: Texture = $ContenedorCorazones/Corazon2.texture


const VIDA_POR_CORAZON := 10
@onready var container = $ContenedorCorazones
var corazones: Array[TextureRect] = []

func _ready():
	print("ContenedorCorazones es: ", container)
	for nodo in container.get_children():
		if nodo is TextureRect:
			corazones.append(nodo)

func actualizar_vida(vida: int, vida_max: int):
	var corazones_totales = int(ceil(vida_max / VIDA_POR_CORAZON))
	if corazones.size() != corazones_totales:
		crear_corazones(corazones_totales)

	for i in range(corazones.size()):
		var valor = vida - (i * VIDA_POR_CORAZON)
		if valor >= VIDA_POR_CORAZON:
			corazones[i].texture = corazon_lleno
		else:
			corazones[i].texture = corazon_vacio

			
func crear_corazones(cantidad: int):
	for hijo in container.get_children():
		hijo.queue_free()
	corazones.clear()

	# Crear los corazones
	for i in range(cantidad):
		var corazon = TextureRect.new()
		corazon.texture = corazon_lleno
		corazon.expand_mode = TextureRect.EXPAND_KEEP_SIZE
		corazon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		container.add_child(corazon)
		corazones.append(corazon)
