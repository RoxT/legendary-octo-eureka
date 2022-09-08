extends Node2D


export (int) var speed = 50
onready var target

var emotion = NEUTRAL
var direction = DOWN
var motion = STOP

const GO = "go"
const STOP = "stop"

const UP = "up"
const DOWN = "down"
const RIGHT = "right"
const LEFT = "left"
var directions = [UP, DOWN, RIGHT, LEFT]


const NEUTRAL = "neutral"
const ANGRY = "angry"
const TIRED = "tired"
const CUTE = "cute"
var emotions = [NEUTRAL, ANGRY, TIRED, CUTE]

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
func getDirection():
	return directions[randi() % directions.size()]

func getEmotion():
	return emotions[randi() % emotions.size()]

func _input(event):
	if event.is_action_pressed("click"):
		#target = get_global_mouse_position()
		target = $Fridge.position + $Fridge/Spot.position

func _physics_process(delta):
	if target != null:
		var velocity = $Human.position.direction_to(target) * speed
		# look_at(target)
		var distance = $Human.position.distance_to(target)
		
		if  distance > 1:
			$Human.move_and_slide(velocity)
		else:
			target = null


func _on_Schedule_timeout():
	update_sprite()
	
func update_sprite():
	var dir = getDirection()
	var emo = getEmotion()
	if dir == LEFT:
		$Human/AnimatedSprite.flip_h = true
		dir = "side"
	if dir == RIGHT:
		$Human/AnimatedSprite.flip_h = false
		dir = "side"
	if dir == UP:
		emo = ""
	
	var formatName = "%s_%s"
	$DebugLabel.text = formatName % [dir, emo]
	$Human/AnimatedSprite.animation = formatName % [dir, emo]
