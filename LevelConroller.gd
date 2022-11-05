extends Node2D


const DEFAULT = "default"
onready var hunger_full = $Bars/Hunger.frames.get_frame_count(DEFAULT)

var score: int
var sleeping: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0;
	$Bars/Hunger.frame = 0
	$Bars/Hunger.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	if sleeping:
		score += 1
		change_debug_label(score)

func _on_Food_body_entered(body):
	if body.name == "PlayerCat":
		
		if $Food/AnimatedSprite.frame == $Food.FOOD_FULL:
			$Bars.eat()
			$Food.empty()
			
func change_debug_label(text):
	var formatDebug = "%s"
	$DebugLabel.text = formatDebug % text

func _on_Sleep_pressed():
	$PlayerCat.sleep_toggle()

func _on_PlayerCat_cat_sleep():
	sleeping = true
	$Bars.sleep()

func _on_PlayerCat_cat_wake():
	sleeping = false
	$Bars.wake()

func _on_Energy_animation_finished():
	if sleeping:
		$PlayerCat.sleep_toggle()
