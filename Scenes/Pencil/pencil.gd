extends Line2D

@export var drawing_node_path: NodePath

func _physics_process(delta: float) -> void:
	var drawing_node: Node2D = get_node(drawing_node_path)
	add_point(drawing_node.global_position + drawing_node.line * drawing_node.scale_lines)
