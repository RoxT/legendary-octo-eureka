extends AnimatedSprite

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

var prev_dir:String
var prev_emo:String

onready var body:Area2D = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func getRandomEmotion():
	return emotions[randi() % emotions.size()]

func getRandomDirection():
	return directions[randi() % directions.size()]
	
func update_sprite(dir:String, emo:String):
	if dir == LEFT:
		self.flip_h = true
		dir = "side"
	if dir == RIGHT:
		self.flip_h = false
		dir = "side"
	if dir == UP:
		emo = ""
	
	var formatName = "%s_%s"
	self.animation = formatName % [dir, emo]
	
func distract(target:Vector2, emo:String = emotion):
	prev_dir = direction
	turn_towards(target, emo)
	$Distracted.start()
	
func face(new_dir:String):
	assert(directions.has(new_dir), "Direction to face is not a  direction: " + new_dir)
	update_sprite(new_dir, emotion)

func turn_towards(target:Vector2, emo:String = emotion):
	var dist: Vector2 = body.position - target
	if abs(dist.x) > abs(dist.y) || dist.y > 0:
		if dist.x > 0:
			update_sprite(LEFT, emo)
		else:
			update_sprite(RIGHT, emo)
	else:
		update_sprite(DOWN, emo)

	
func _on_Schedule_timeout():
	update_sprite(getRandomDirection(), getRandomEmotion())
	
func _on_Distracted_timeout():
	update_sprite(prev_dir, NEUTRAL)
