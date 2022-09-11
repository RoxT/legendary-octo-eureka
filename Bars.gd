extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func eat():
	$Hunger.frame = 0
	$Hunger.play()

func sleep():
	$Energy.play("default", false)

func wake():
	$Energy.play("defualt", true)
