extends TextureProgress

export var tired_threshold:int = 1000
export var recovery_rate:int = 3
onready var label = $Label
const PLAYFULL_TITLE = "Playfull!"
const SLEEPY_TITLE = "Sleepy"
var sleeping:bool = false
signal fully_napped

# Called when the node enters the scene tree for the first time.
func _ready():
	value = max_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sleeping:
		value = value + step*recovery_rate
	else:
		value = value - step*recovery_rate

	label.text = SLEEPY_TITLE if value <= tired_threshold else PLAYFULL_TITLE
	if value >= max_value:
		emit_signal("fully_napped")
		
func wake():
	sleeping = false
	
func sleep():
	sleeping = true
	
func drain(amount: int):
	value = value - amount
