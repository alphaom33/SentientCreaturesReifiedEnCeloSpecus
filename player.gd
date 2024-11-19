extends RigidBody2D

var horizonZeroSpeed = 2000
var negatSpeed = 13
var maxHorizonSpeed = 500

var skyMove = 2000
var maxAir = Vector2(400, 1000)
var airDrag = 1

var jump = 30000
var normalGrav = 1

var numJumps = 1
var isOnGround = false
signal ground(newGround);

var poinch: PackedScene
var offset = Vector2(50, 0)

var sword: PackedScene
signal newSword(sign, off, rot)
var inSpecial = false

var crouch: PackedScene

var sprite: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	onGround()
	poinch = load("res://fist.tscn")
	crouch = load("res://crouch.tscn")
	sword = load("res://sword.tscn")
	sprite = $"Sprite2D"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	rotation = 0

	if isOnGround:
		groundMove()
	else:
		airMove()

	if not inSpecial:
		joinp()
		fisticuffs()

func onGround():
	var collision = $"Area2D"
	collision.connect("area_entered", go)
	collision.connect("area_exited", leave)

func go(area: Area2D):
	if area.is_in_group("ground"):
		numJumps = 2
		isOnGround = true
		ground.emit(isOnGround)
		gravity_scale = normalGrav

func leave(area):
	if area.is_in_group("ground"):
		numJumps = 1
		isOnGround = false
		ground.emit(isOnGround)
	elif (area.is_in_group("death")):
		kill()

func groundMove():
	if Input.is_action_pressed("move_left") and not inSpecial:
		apply_central_force(Vector2.LEFT * horizonZeroSpeed)
		sprite.scale.x = -0.65
	elif Input.is_action_pressed("move_right") and not inSpecial:
		apply_central_force(Vector2.RIGHT * horizonZeroSpeed)
		sprite.scale.x = 0.65
	else:
		apply_central_force(Vector2(-linear_velocity.x * negatSpeed, 0))
		
	var dir = clamp(sign(sprite.scale.x), 0, 1)
	linear_velocity.x = clamp(linear_velocity.x, (1 - dir) * -maxHorizonSpeed, dir * maxHorizonSpeed)
	
	if Input.is_action_pressed("crouch"):
		var newMe = crouch.instantiate()
		get_parent().add_child(newMe)
		get_parent().get_node("Crouch").position = position + Vector2(0, 25)
		queue_free()

func airMove():
	if Input.is_action_pressed("move_left") and linear_velocity.x > -maxAir.x:
		apply_central_force(Vector2.LEFT * skyMove)
	elif Input.is_action_pressed("move_right") and linear_velocity.x < maxAir.x:
		apply_central_force(Vector2.RIGHT * skyMove)
	else:
		apply_central_force(Vector2(-linear_velocity.x * airDrag, 0))

func joinp():
	if Input.is_action_just_pressed("jump") and (numJumps > 0):
		numJumps -= 1
		linear_velocity = Vector2(linear_velocity.x, clamp(linear_velocity.y, 0, float('inf')))
		apply_central_force(Vector2.UP * jump)

func fisticuffs():
	if (Input.is_action_just_pressed("faaaaalcon")):
		var yes = poinch.instantiate()
		get_parent().add_child(yes)
		get_parent().get_node("Fist").position = position + Vector2(offset.x * sign(sprite.scale.x), offset.y)

func speedReset():
	maxHorizonSpeed = 500
	inSpecial = false
	negatSpeed = 13

func kill():
	pass
