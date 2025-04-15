extends Node2D

@export var coff: Vector2
@export var index: int

@onready var manager: Node2D
@onready var N: int = manager.fourier_coffs.size()
@onready var scale_lines: float = manager.scale_lines

@onready var line: Vector2 = coff

func update_line() -> void:
	line = line.rotated(2 * PI * index * 1/float(N))
	
	var visible_line: Vector2 = line * scale_lines
	$Line2D.points[1] = visible_line
	$Tip.position = visible_line
	
func _physics_process(delta: float) -> void:
	if manager.running:
		update_line()
