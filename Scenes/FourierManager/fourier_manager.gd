extends Node2D

@export var coefficients_file_path: String = "fourier_coffs.txt"
@export var coff_count: int = -1

@export var running: bool = false
@export var sorted: bool = true
@export var will_add_pencil: bool = true

@export var scale_lines: float = 1.0

var epicycle_scene: PackedScene = preload("res://Scenes/Epicycle/epicycle.tscn")
var pencil_scene: PackedScene = preload("res://Scenes/Pencil/pencil.tscn")

var fourier_coffs: Array[Vector2] = []
@onready var fourier_data: Array = []

func initialize_fourier_data(N: int) -> void:
	fourier_data.resize(N)
	
	for k in range(N):
		var current: Array = [fourier_coffs[k], k]
		fourier_data[k] = current

func fourier_data_cmp(v1: Array, v2: Array) -> bool:
	return v1[0].length() > v2[0].length()

func load_fourier_coffs() -> void:
	var fullpath: String = "user://" + coefficients_file_path
	
	if not FileAccess.file_exists(fullpath):
		print("Hello? The coefficients file doesn't even exist as " + fullpath + ". What am I even supposed to work with???")
		return
		
	var file = FileAccess.open(fullpath, FileAccess.READ)
	
	if !file:
		print("Ohh noo! I am unable to open the file at path " + fullpath + "! Now I'm sad :(")
		return
	
	while file.get_position() < file.get_length():
		var line: String = file.get_line()
		
		if line[0] == '#':
			continue;
		
		var vector_tokens: PackedStringArray = line.split(" ", false)
		for vector_token in vector_tokens:
			var float_toks: PackedStringArray = vector_token.split(",")
			var real_component: float = float(float_toks[0].split("(")[1])
			var imag_component: float = float(float_toks[1].split(")")[0])
			var new_vector: Vector2 = Vector2(real_component, imag_component)
			fourier_coffs.push_back(new_vector)
			
			
	var preliminary_N: int = fourier_coffs.size()
	if coff_count <= preliminary_N:
		print("Provided coff_count value does not add padding.")
	else:
		for i in range(coff_count - preliminary_N):
			fourier_coffs.push_back(Vector2())
			
	file.close()
	
func prepare_series() -> void:
	load_fourier_coffs()
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
		
	if will_add_pencil and last_epicycle:
		var pencil_instance: Line2D = pencil_scene.instantiate()
		pencil_instance.drawing_node_path = last_epicycle.get_path()
		# adding child after all the epicycles are ready ensures that they do not calculate
		# invalid N value:
		add_child(pencil_instance)
		
func _ready() -> void:
	prepare_series()
