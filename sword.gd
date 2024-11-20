extends Node2D

var timi: Timer
var count_down: float = 0.1
var angle: float = 60

var player: RigidBody2D
signal died

var child: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent()
	timi = $"Timer"
	timi.start(count_down)

	child = $"Node2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if timi.time_left <= 0:
		died.emit()
		queue_free()
	else:
		rotation_degrees = lerp(scale.x * angle, -scale.x * angle, timi.time_left / count_down)

func lerp(a, b, t):
	return a + (b - a) * t
