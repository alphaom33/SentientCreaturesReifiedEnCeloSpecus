extends PointLight2D

var spider: Node2D
var angle: float
var pos: Vector2

var max_length = 300

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if spider and (position - spider.position).length() > max_length:
		var cast_pos = spider.position + pos

		var wall = Vector2.INF
		for x in get_tree().root.get_child(0).get_children():
			if x.is_in_group("wall") && (cast_pos - x.position).length() < (cast_pos - wall).length():
				wall = x.position

		var query = PhysicsRayQueryParameters2D.create(cast_pos, wall)
		var result = get_world_2d().direct_space_state.intersect_ray(query)
		if result.has("normal"):
			query = PhysicsRayQueryParameters2D.create(cast_pos, cast_pos + (-result.normal * 10000))
			result = get_world_2d().direct_space_state.intersect_ray(query)
			if result.has("position"):
				position = result.position
			else:
				print("normal recast failed?")
