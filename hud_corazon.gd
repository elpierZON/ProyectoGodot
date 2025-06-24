extends CanvasLayer

@onready var contenedor := $VidaContainer
@export var corazon_escena: PackedScene

func _ready():
	print("HUD iniciado")
	if corazon_escena:
		mostrar_vida(3, 3)
	else:
		print("⚠️ corazon_escena no asignado")

func mostrar_vida(vida_actual: int, vida_max: int):
	for child in contenedor.get_children():
		child.queue_free()

	for i in range(vida_max):
		var corazon = corazon_escena.instantiate()
		corazon.set_lleno(i < vida_actual)
		contenedor.add_child(corazon)
