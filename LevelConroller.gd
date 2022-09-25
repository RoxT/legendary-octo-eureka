extends Node2D


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
		
		if $Food/AnimatedSprite.frame == $Food.FOOD_FULL:
			$Bars.eat()
			$Food.empty()


func _on_Sleep_pressed():
	$PlayerCat.sleep_toggle()
	$Bars.sleep()

func _on_Jump_pressed():
	$PlayerCat.target_jump()


func _on_PlayerCat_cat_sleep():
	$Bars.sleep()


func _on_PlayerCat_cat_wake():
	$Bars.wake()

