extends Node2D

var emotion = NEUTRAL
var direction = DOWN

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

onready var human_sprite = $Node2D/Human/Body/AnimatedSprite

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
		pass

func _physics_process(delta):
	pass 

func update_sprite():
	var dir = getDirection()
	var emo = getEmotion()
	if dir == LEFT:
		human_sprite.flip_h = true
		dir = "side"
	if dir == RIGHT:
		human_sprite.flip_h = false
		dir = "side"
	if dir == UP:
		emo = ""
	
	var formatName = "%s_%s"
	$Node2D/DebugLabel.text = formatName % [dir, emo]
	human_sprite.animation = formatName % [dir, emo]


func _on_Schedule_timeout():
	update_sprite()
