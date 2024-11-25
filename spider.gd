extends Node2D

var player: Node2D
var speed = 50
var minDst = 100

var max_ready_timer = 0.7
var readyTimer: Timer

var surge_pos: Vector2
var max_surge_timer = 1
var surge_timer = 0
var surge_speed = 600

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().root.get_child(0).get_node("Player")

	readyTimer = $"ReadyTimer"
	readyTimer.connect("timeout", func():
		surge_pos = player.position
		surge_timer = max_surge_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dst = player.position - position

	print(surge_timer)
	if (dst.length() > minDst):
		position += dst.normalized() * delta * speed
		readyTimer.stop()
		readyTimer.start(max_ready_timer)
	elif (surge_timer > 0):
		surge_timer -= delta
		position += dst.normalized() * delta * surge_speed
		readyTimer.stop()
		readyTimer.start(max_ready_timer)
