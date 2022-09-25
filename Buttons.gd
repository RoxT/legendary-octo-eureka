extends Position2D


var up: bool = false
var down: bool = false
var left: bool = false
var right: bool = false

const UP = "up"
const DOWN = "down"
const RIGHT = "right"
const LEFT = "left"

var pressed = []

enum frames{NONE, UP, NE, RIGHT, SE, DOWN, SW, LEFT, NW}


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for d in pressed:
		do_button(d, true)


func _on_Up_button_down():
	pressed = [UP]
	$AnimatedSprite.frame = frames.UP

func _on_Up_button_up():
	reset_dpad(UP)
	
func reset_dpad(dir: String):
	pressed = []
	do_button(dir, false)
	$AnimatedSprite.frame = frames.NONE
	
func do_button(dir: String, pressed: bool):
	var ev = InputEventAction.new()
	var action_name = "ui_%s"
	ev.action = action_name % dir
	ev.pressed = pressed
	Input.parse_input_event(ev)

func _on_NE_button_down():
	pressed = [UP, RIGHT]
	$AnimatedSprite.frame = frames.NE

func _on_NE_button_up():
	reset_dpad(UP)
	reset_dpad(RIGHT)

func _on_Right_button_down():
	pressed = [RIGHT]
	$AnimatedSprite.frame = frames.RIGHT

func _on_Right_button_up():
	reset_dpad(RIGHT)
	
func _on_SE_button_down():
	pressed = [DOWN, RIGHT]
	$AnimatedSprite.frame = frames.SE

func _on_SE_button_up():
	reset_dpad(RIGHT)
	reset_dpad(DOWN)

func _on_Down_button_down():
	pressed = [DOWN]
	$AnimatedSprite.frame = frames.DOWN

func _on_Down_button_up():
	reset_dpad(DOWN)

func _on_SW_button_down():
	pressed = [DOWN, LEFT]
	$AnimatedSprite.frame = frames.SW

func _on_SW_button_up():
	reset_dpad(LEFT)
	reset_dpad(DOWN)

func _on_Left_button_down():
	pressed = [LEFT]
	$AnimatedSprite.frame = frames.LEFT

func _on_Left_button_up():
	reset_dpad(LEFT)

func _on_NW_button_down():
	pressed = [LEFT, UP]
	$AnimatedSprite.frame = frames.NW

func _on_NW_button_up():
	reset_dpad(LEFT)
	reset_dpad(UP)
