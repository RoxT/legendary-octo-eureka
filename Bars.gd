extends Control

onready var hunger = get_node("Hunger")

export var FOOD_VALUE = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	wake()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func eat():
	hunger.frame = max((hunger.frame - FOOD_VALUE), 0)
	hunger.play()

func sleep():
	$Energy.play("default", false)

func wake():
	$Energy.play("default", true)
