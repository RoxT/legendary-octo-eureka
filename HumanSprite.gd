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
	
func update_sprite():
	var dir = getRandomDirection()
	var emo = getRandomEmotion()
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
	
func _on_Schedule_timeout():
	update_sprite()
