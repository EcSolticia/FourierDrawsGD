extends Node2D

@export var customizable: bool = false
@export var running: bool = false
@export var sorted: bool = true

@export var scale_lines: float = 1.0

var epicycle_scene: PackedScene = preload("res://Scenes/Epicycle/epicycle.tscn")

@export var fourier_coffs: Array[Vector2] = []

func prepare_series() -> void:
	if sorted:
		print("Sorting of coefficients not yet implemented!")
	
	var N: int = fourier_coffs.size()
	var last_epicycle: Node2D
	for k in range(N):
		var epicycle = epicycle_scene.instantiate()
		
		epicycle.index = k
		epicycle.coff = fourier_coffs[k]
		epicycle.manager = self
		
		if !k:
			add_child(epicycle)
		else:
			last_epicycle.get_node("Tip").add_child(epicycle)
		
		last_epicycle = epicycle
		
func _ready() -> void:
	if !customizable:
		prepare_series()		
