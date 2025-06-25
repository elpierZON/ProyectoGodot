extends CanvasLayer

@export var corazon_lleno: AtlasTexture
@export var corazon_mitad: AtlasTexture
@export var corazon_vacio: AtlasTexture

const VIDA_POR_CORAZON := 5

@onready var container = $ContenedoresCorazones
var corazones: Array[TextureRect] = []

func _ready():
	for nodo in container.get_children():
		if nodo is TextureRect:
			corazones.append(nodo)

func actualizar_vida(vida: int, vida_max: int):
	var corazones_totales = int(ceil(vida_max / VIDA_POR_CORAZON))

	for i in range(corazones.size()):
		if i < corazones_totales:
			var valor = vida - (i * VIDA_POR_CORAZON)
			if valor >= VIDA_POR_CORAZON:
				corazones[i].texture = corazon_lleno
			elif valor >= VIDA_POR_CORAZON / 2:
				corazones[i].texture = corazon_mitad
			else:
				corazones[i].texture = corazon_vacio
		else:
			corazones[i].texture = null  # o corazones[i].hide()
