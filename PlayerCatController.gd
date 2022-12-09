extends KinematicBody2D

export var speed: int = 100;
export var jump_modifier = 1.5
export var reticule_modifier = 15
onready var sprite = get_node("AnimatedSprite")
const BALL = "Ball"
var direction: Vector2 = Vector2(1, 0)
var area_clear: bool = false
var jump_target: Vector2
var can_jump: bool
signal cat_wake
signal cat_sleep

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.animation = "run"

func _physics_process(delta):
	if sprite.animation == "jump" && can_jump:
		move_and_collide(jump_target * jump_modifier * delta)
	
	if Input.is_action_just_pressed("sleep"):
		sleep_toggle()
	if Input.is_action_just_pressed("jump") && sprite.animation != "sleep":
		target_jump()
	if sprite.animation == "run":
		if direction != Vector2.ZERO:
			do_run(delta)
		else:
			check_input_and_run(delta)

func target_jump():
	if area_clear:
		jump_target = $CollisionShape2D/Area2D.position
		collision_layer = 0
		collision_mask = 0
		can_jump = true
	else:
		can_jump = false
	sprite.animation = "jump"

func sleep_toggle():
	if sprite.animation == "sleep":
		sprite.animation = "run"
		emit_signal("cat_wake")
	elif sprite.animation == "run":
		sprite.animation = "loaf"
	
func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "loaf":
		sprite.animation = "sleep"
		emit_signal("cat_sleep")
	elif sprite.animation == "jump":
		sprite.animation = "run"
		collision_layer = 1
		collision_mask = 1
	elif sprite.animation == "eat":
		sprite.animation = "run"
	elif sprite.animation == "vomit":
		sprite.animation = "run"
		
func eat():
	sprite.animation = "eat"
	
func vomit():
	sprite.animation = "vomit"
	
func meow():
	$AudioStreamPlayer2D.play()

func check_input_and_run(delta):
	var x = 0;
	var y = 0;
	if Input.is_action_pressed("ui_right") || \
			Input.is_action_pressed("ui_up_right") || \
			Input.is_action_pressed("ui_down_right"):
		x = 1;
		sprite.flip_h = false;
	elif (Input.is_action_pressed("ui_left")) || \
			(Input.is_action_pressed("ui_up_left")) || \
			(Input.is_action_pressed("ui_down_left")):
		x = -1;
		sprite.flip_h = true;
	if (Input.is_action_pressed("ui_up")) || \
			(Input.is_action_pressed("ui_up_left")) || \
			(Input.is_action_pressed("ui_up_right")):
		y = -1;
	elif (Input.is_action_pressed("ui_down")) || \
			(Input.is_action_pressed("ui_down_left")) || \
			(Input.is_action_pressed("ui_down_right")):
		y = 1;
	direction = Vector2(x, y).normalized()
	if direction != Vector2.ZERO:
		$CollisionShape2D/Area2D.position = direction * reticule_modifier
	do_run(delta)

func set_direction(dir: Vector2):
	direction = dir

func do_run(delta):
	move_and_collide(direction * speed * delta)
	if sprite.animation != "jump":
		direction = Vector2(0, 0)

func layerJump(collision):
	if collision != null:
		if (Input.is_action_just_pressed("jump")):
			#does c have JumpTo node
			var furnature:Node = collision.get_collider().get_parent().get_parent()
			if furnature.has_node("JumpTo"):
				position = furnature.get_node("JumpTo").position	#Jumping

func _on_Area2D_body_entered(body):
	if body.name != BALL:
		area_clear = false
		$CollisionShape2D/Area2D/Debug/ColorRect.visible = true


func _on_Area2D_body_exited(_body):
	area_clear = true
	$CollisionShape2D/Area2D/Debug/ColorRect.visible = false
	

