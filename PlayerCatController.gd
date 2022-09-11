extends KinematicBody2D

export var speed: int = 150;
onready var sprite = get_node("AnimatedSprite")
var direction: Vector2 = Vector2(1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.animation = "run"

func _physics_process(delta):
	
	if sprite.animation == "jump":
		move_and_slide(direction * speed/3)
	
	if Input.is_action_just_pressed("sleep"):
		if sprite.animation == "sleep":
			end_loaf()
		elif sprite.animation == "run":
			start_loaf()
	if sprite.animation == "run":
		run(delta)
		
	if Input.is_action_just_pressed("jump"):
		sprite.animation = "jump"
		collision_layer = 0
		collision_mask = 0

	
func start_loaf():
	sprite.animation = "loaf"
	
func end_loaf():
	sprite.animation = "run"
	
func _on_AnimatedSprite_animation_finished():
	if sprite.animation == "loaf":
		sprite.animation = "sleep"
	if sprite.animation == "jump":
		sprite.animation = "run"
		collision_layer = 1
		collision_mask = 1

func run(delta):
	var x = 0;
	var y = 0;
	if Input.is_action_pressed("ui_right"):
		x = 1;
		sprite.flip_h = false;
	elif (Input.is_action_pressed("ui_left")):
		x = -1;
		sprite.flip_h = true;
	if (Input.is_action_pressed("ui_up")):
		y = -1;
	elif (Input.is_action_pressed("ui_down")):
		y = 1;
		
	direction = Vector2(x, y).normalized()
	
	var collision = move_and_collide(direction * speed * delta);
	
func layerJump(collision):
	if collision != null:
		if (Input.is_action_just_pressed("jump")):
			#does c have JumpTo node
			var furnature:Node = collision.get_collider().get_parent().get_parent()
			if furnature.has_node("JumpTo"):
				position = furnature.get_node("JumpTo").position	#Jumping
		
		#Turn off masks
		
		#move to JumpTo
		
		#Turn on layer/mask 2
