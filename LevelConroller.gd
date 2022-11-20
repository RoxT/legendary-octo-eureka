extends Node2D


const DEFAULT = "default"
onready var hunger_full = $Bars/Hunger.frames.get_frame_count(DEFAULT)-1

var score: int
var sleeping: bool = false

const default_multiplier = 10
const CAT = "PlayerCat"
var ach_bed: bool = false
const bed_multiplier = 0.2
const BED_NAME = "Slept on Bed"
var ach_ball: bool = false
var ball_modifier = 0.2
const BALL_NAME = "Played with Ball"

var achieved = {
	"BED_NAME" : false,
	"BALL_NAME" : false
}

var config
const FILE_NAME = "user://configs.cfg"
const SECTION_ACHIEVEMENTS = "achievements"

# Called when the node enters the scene tree for the first time.
func _ready():
	score = 0;
	$Bars/Hunger.frame = 0
	$Bars/Hunger.play()
	config = ConfigFile.new()
	var err = config.load(FILE_NAME)
	if err != OK:
		print(err)
	achieved[BALL_NAME] = config.get_value(SECTION_ACHIEVEMENTS, BALL_NAME, false)
	achieved[BED_NAME] = config.get_value(SECTION_ACHIEVEMENTS, BED_NAME, false)
	print("Ball:",config.get_value(SECTION_ACHIEVEMENTS, BALL_NAME, false), 
		"Bed:",config.get_value(SECTION_ACHIEVEMENTS, BED_NAME, false))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	if sleeping:
		var modifiers = 1 + (bed_multiplier if ach_bed else 0) + (ball_modifier if ach_ball else 0)
		score = score + default_multiplier * modifiers
		change_debug_label($DebugLabel, score)
		change_debug_label($Modifier, modifiers)

func _on_Food_body_entered(body):
	if body.name == "PlayerCat":
		
		if $Food/AnimatedSprite.frame == $Food.FOOD_FULL:
			$Bars.eat()
			$Food.empty()
			$PlayerCat.eat()
			
func change_debug_label(label: Label, text):
	var formatDebug = "%s"
	label.text = formatDebug % text

func _on_Sleep_pressed():
	$PlayerCat.sleep_toggle()

func _on_PlayerCat_cat_sleep():
	if ($Bars/Hunger.frame == hunger_full):
		$PlayerCat.sleep_toggle()
	else:
		sleeping = true
		$Bars.sleep()
		if ach_bed:
			achieved[BED_NAME] = true
		if ach_ball:
			achieved[BALL_NAME] = true
		config.set_value(SECTION_ACHIEVEMENTS, BED_NAME, achieved[BED_NAME])
		config.set_value(SECTION_ACHIEVEMENTS, BALL_NAME, achieved[BALL_NAME])
		config.save(FILE_NAME)
		print("Ball:",config.get_value(SECTION_ACHIEVEMENTS, BALL_NAME, false), 
			"Bed:",config.get_value(SECTION_ACHIEVEMENTS, BED_NAME, false))
		

func _on_PlayerCat_cat_wake():
	sleeping = false
	$Bars.wake()
	ach_ball = false

func _on_Energy_animation_finished():
	if sleeping:
		$PlayerCat.sleep_toggle()

func _on_Hunger_animation_finished():
	if sleeping :
		$PlayerCat.sleep_toggle()


func _on_AchBed_body_entered(body):
	print(body.name, " is on the bed")
	if body.name == CAT:
		ach_bed = true


func _on_AchBed_body_exited(body):
	print(body.name, " is off the bed")
	if body.name == CAT:
		ach_bed = false


func _on_Ball_body_entered(body):
	if body.name == CAT:
		$Ball/BallAudioStreamPlayer.play()
		ach_ball = true
