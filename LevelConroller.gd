extends Node2D


const DEFAULT = "default"
onready var hunger_full = $Bars/Hunger.frames.get_frame_count(DEFAULT)-1

var score: int
var sleeping: bool = false

const default_multiplier = 10
const CAT = "PlayerCat"

class Achievement:
	var name: String
	var multiplier: int = 0
	var active: bool = false
	var achieved: bool = false
	
	func _init(name, multiplier):
		self.name = name
		self.multiplier = multiplier

var slept_on_bed: Achievement
var played_with_ball: Achievement

var config
const FILE_NAME = "user://configs.cfg"
const SECTION_ACHIEVEMENTS = "achievements"

# Called when the node enters the scene tree for the first time.
func _ready():
	slept_on_bed = Achievement.new("slept_on_bed", 0.2)
	played_with_ball = Achievement.new("played_with_ball", 0.2)
	score = 0;
	$Bars/Hunger.frame = 0
	$Bars/Hunger.play()
	config = ConfigFile.new()
	var err = config.load(FILE_NAME)
	if err != OK:
		print(err)
	played_with_ball.achieved = config.get_value(SECTION_ACHIEVEMENTS, played_with_ball.name, false)
	slept_on_bed.achieved = config.get_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, false)
	print("Ball:",config.get_value(SECTION_ACHIEVEMENTS, played_with_ball.name, false), 
		"Bed:",config.get_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, false))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	if sleeping:
		var modifiers = 1 + (slept_on_bed.multiplier if slept_on_bed.active else 0) + (played_with_ball.multiplier if played_with_ball.active else 0)
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
		if slept_on_bed.active:
			slept_on_bed.achieved = true
		if played_with_ball.active:
			played_with_ball.achieved = true
		config.set_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, slept_on_bed.achieved)
		config.set_value(SECTION_ACHIEVEMENTS, played_with_ball.name, played_with_ball.achieved)
		config.save(FILE_NAME)
		print("Ball:",config.get_value(SECTION_ACHIEVEMENTS, played_with_ball.name, false), 
			"Bed:",config.get_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, false))
		

func _on_PlayerCat_cat_wake():
	sleeping = false
	$Bars.wake()
	played_with_ball.active = false

func _on_Energy_animation_finished():
	if sleeping:
		$PlayerCat.sleep_toggle()

func _on_Hunger_animation_finished():
	if sleeping :
		$PlayerCat.sleep_toggle()


func _on_AchBed_body_entered(body):
	print(body.name, " is on the bed")
	if body.name == CAT:
		slept_on_bed.active = true


func _on_AchBed_body_exited(body):
	print(body.name, " is off the bed")
	if body.name == CAT:
		slept_on_bed.active = false


func _on_Ball_body_entered(body):
	if body.name == CAT:
		$Ball/BallAudioStreamPlayer.play()
		played_with_ball.active = true
