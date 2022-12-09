extends TextureProgress

export var food_value:int = 2500
export var hungry_threshold = 500
export var vomit_loss = 700
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
	label.text = ""
	if value <= hungry_threshold:
		label.text = HUNGRY_TITLE 
	elif value >= max_value-hungry_threshold:
		label.text = FULL_TITLE
	
	if value <= min_value:
		emit_signal("too_hungry")
	
func eat():
	if value >= max_value-hungry_threshold:
		$Vomit.start()
	value = value + food_value

func vomit():
	value = value - vomit_loss
