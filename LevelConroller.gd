extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const FOOD_FULL = 1
const FOOD_EMPTY = 0
const DEFAULT = "default"
onready var hunger_full = $Bars/Hunger.frames.get_frame_count(DEFAULT)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Bars/Hunger.frame = 0
	$Bars/Hunger.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Food_body_entered(body):

	if body.name == "PlayerCat":
		var formatDebug = "%s"
		$DebugLabel.text = formatDebug % $Food/AnimatedSprite.frame
		if $Food/AnimatedSprite.frame == FOOD_FULL:
			$Bars/Hunger.frame = clamp(
				$Bars/Hunger.frame-1, 
				0, 
				hunger_full)
			$Bars/Hunger.play()
