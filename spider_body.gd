extends Node2D

var player: Node2D
var speed = 50
var minDst = 100

var spider_body: Node2D

var max_ready_timer = 0.7
var readyTimer: Timer

var surge_direction: Vector2
var max_surge_timer = 1
var surge_timer = 0
var surge_speed = 600

var dst

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().root.get_child(0).get_node("Player")

	readyTimer = $"ReadyTimer"
	readyTimer.connect("timeout", func():
		surge_direction = (player.position - position).normalized() 
		surge_timer = max_surge_timer)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dst = player.position - position

	if (dst.length() > minDst):
		position += dst.normalized() * delta * speed
		readyTimer.stop()
		readyTimer.start(max_ready_timer)
	elif (surge_timer > 0):
		surge_timer -= delta
		position += surge_direction * delta * surge_speed
		readyTimer.stop()
		readyTimer.start(max_ready_timer)
