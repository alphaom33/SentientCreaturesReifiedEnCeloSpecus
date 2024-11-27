extends Node2D

@export var start_pos: Vector2

var body: Node2D

@export var num_legs = 8
var leg: PackedScene
var base_spider_width = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leg = load("res://spider_leg.tscn")

	body = $"SpiderBody"
	body.position = start_pos
	var radius = body.scale.x

	for i in range(0, num_legs):
		var new_leg = leg.instantiate()
		new_leg.spider = body
		var angle = i as float / num_legs * TAU
		new_leg.pos = (Vector2(cos(angle), sin(angle)) * radius * base_spider_width)
		new_leg.position = start_pos + new_leg.pos
		new_leg.angle = angle
		add_child(new_leg)
