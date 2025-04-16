extends Line2D

@export var drawing_node_path: NodePath

func coordinate_inner_line2d() -> void:
	$Inner.points = points

func _physics_process(delta: float) -> void:
	var drawing_node: Node2D = get_node(drawing_node_path)
	add_point(drawing_node.global_position + drawing_node.line)
	
	coordinate_inner_line2d()
