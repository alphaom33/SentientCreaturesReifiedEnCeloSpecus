extends Node2D

var health = 1

var velocity = Vector2()
var max_speed = 5
var acceleration = 10

var change_point = 10
var current_pos: Vector2
var max_dst: Vector2
var margin = 10
var change_speed = 1

var timi: Timer

var camera: Camera2D

var death_particles: PackedScene

func toward_point():
	return (current_pos - position).normalized()

func limit_speed(vel: Vector2):
	if (vel.length() > max_speed):
		return vel.normalized() * max_speed
	else:
		return vel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_tree().root.get_child(0).get_node("Camera2D")

	max_dst = get_viewport_rect().size / 2 + Vector2(margin, margin)
	random_screen_point()

	timi = $"Timer"
	timi.stop()
	timi.start(change_speed)
	timi.connect("timeout", random_screen_point)

	death_particles = load("res://death_particles.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity += toward_point() * delta * acceleration
	velocity = limit_speed(velocity)
	position += velocity

	if ((position - current_pos).length() < change_point):
		random_screen_point()
		timi.start(change_speed)

func random_screen_point():
	current_pos = camera.position + (Vector2(randf() * 2 - 1, randf() * 2 - 1) * max_dst)

func damage(_amount):
	var thing = death_particles.instantiate()
	thing.position = position
	get_node("/root").add_child(thing)
	queue_free()
