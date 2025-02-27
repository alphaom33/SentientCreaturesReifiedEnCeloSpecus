extends PointLight2D

var spider: Node2D
var angle: float
var pos: Vector2

var max_length = 200
var reach = max_length - 50

var speed = 0.05
var goal_pos

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func get_pos() -> Vector2:
	return spider.position + pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if goal_pos:
		position = position.lerp(goal_pos, speed)

	if spider and spider.dst.dot(position - spider.position) < -0.5 and (spider.position - position).length() > 150:
		var cast_pos = get_pos()

		var query = PhysicsRayQueryParameters2D.create(cast_pos, cast_pos + spider.dst.normalized() * max_length, 0b10)
		var result = get_world_2d().direct_space_state.intersect_ray(query)
		if not result.is_empty():
			var dst = result.position - cast_pos
			if dst.length() >= max_length:
				dst = dst.normalized() * reach
			goal_pos = dst + cast_pos
		else:
			goal_pos = spider.dst.normalized() * max_length + cast_pos
