extends Node2D

@export var customizable: bool = false
@export var running: bool = false
@export var sorted: bool = true
@export var will_add_pencil: bool = true

@export var scale_lines: float = 1.0

var epicycle_scene: PackedScene = preload("res://Scenes/Epicycle/epicycle.tscn")
var pencil_scene: PackedScene = preload("res://Scenes/Pencil/pencil.tscn")

@export var fourier_coffs: Array[Vector2] = []
@onready var fourier_data: Array = []

func initialize_fourier_data(N: int) -> void:
	fourier_data.resize(N)
	for k in range(N):
		var current: Array = [fourier_coffs[k], k]
		fourier_data[k] = current

func fourier_data_cmp(v1: Array, v2: Array) -> bool:
	return v1[0].length() > v2[0].length()

func prepare_series() -> void:
	var N: int = fourier_coffs.size()
	initialize_fourier_data(N)
	
	if sorted:
		fourier_data.sort_custom(fourier_data_cmp)
	
	var last_epicycle: Node2D
	for k in range(N):
		var epicycle = epicycle_scene.instantiate()
		
		epicycle.freq = fourier_data[k][1]
		epicycle.coff = fourier_data[k][0]
		epicycle.manager = self
		
		if !k:
			add_child(epicycle)
		else:
			last_epicycle.get_node("Tip").add_child(epicycle)
		
		last_epicycle = epicycle
		
	if will_add_pencil:
		var pencil_instance: Line2D = pencil_scene.instantiate()
		pencil_instance.drawing_node_path = last_epicycle.get_path()
		# adding child after all the epicycles are ready ensures that they do not calculate
		# invalid N value:
		add_child(pencil_instance)
		
func _ready() -> void:
	if !customizable:
		prepare_series()		
