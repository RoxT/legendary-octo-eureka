extends TextureProgress

export var food_value:int = 2500
export var hungry_threshold = 500
const HUNGRY_TITLE = "Hungry!"
const FULL_TITLE = "Full"
onready var label = $Label
signal too_hungry

# Called when the node enters the scene tree for the first time.
func _ready():
	value = max_value


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	value = value-step
	if value <= hungry_threshold:
		label.text = HUNGRY_TITLE
	else:
		label.text = FULL_TITLE
	if value <= min_value:
		emit_signal("too_hungry")
	
func eat():
	value = value + food_value
