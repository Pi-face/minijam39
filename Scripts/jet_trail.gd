extends Line2D

@export var max_points : int = 30

func _physics_process(_delta: float) -> void:
	add_point(get_parent().global_position)
	if points.size() > max_points:
		remove_point(0)