extends Node2D

const DEFAULT = "default"
onready var hunger_full = $Bars/Hunger.frames.get_frame_count(DEFAULT)-1

const TITLE_MUPLIPLIERS = "Multipliers this Round:"
const TITLE_END_OF_DAY = "End of Day"

var score: int
var sleeping: bool = false

const default_multiplier = 10.0
const CAT = "PlayerCat"

class Achievement:
	var name: String
	var multiplier: float
	var active: bool = false
	var achieved: bool = false
	var achieved_already:bool = false
	
	func _init(new_name: String, new_multiplier: float):
		self.name = new_name
		self.multiplier = new_multiplier

var achievements = []
var slept_on_bed: Achievement
var played_with_ball: Achievement

var config
const FILE_NAME = "user://configs.cfg"
const SECTION_ACHIEVEMENTS = "achievements"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	slept_on_bed = Achievement.new("slept_on_bed", 0.2)
	achievements.append(slept_on_bed)
	played_with_ball = Achievement.new("played_with_ball", 0.2)
	achievements.append(played_with_ball)
	score = 0;
	$Bars/Hunger.frame = 0
	$Bars/Hunger.play()
	config = ConfigFile.new()
	var err = config.load(FILE_NAME)
	if err != OK:
		print(err)
	played_with_ball.achieved_already = config.get_value(SECTION_ACHIEVEMENTS, played_with_ball.name, false)
	slept_on_bed.achieved_already = config.get_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, false)
	print("Ball:",config.get_value(SECTION_ACHIEVEMENTS, played_with_ball.name, false), 
		"Bed:",config.get_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, false))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	if sleeping:
		var slept_on_bed_mod: float = slept_on_bed.multiplier if slept_on_bed.active else 0.0
		var played_with_ball_mod: float = played_with_ball.multiplier if played_with_ball.active else 0.0
		var modifiers:float = 1 + slept_on_bed_mod + played_with_ball_mod
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

func _on_Meow_pressed():
	$PlayerCat.meow()
	$HumanLife.meow()

func _on_PawsBtn_pressed():
	get_tree().paused = true
	var label:RichTextLabel = $TopUI/PauseDialog/RichTextLabel
	label.clear()
	for a in achievements:
		label.add_text(a.name)
		label.add_text(": ")
		label.add_text("Yes" if a.achieved == true else "No")
		label.newline()
	$TopUI/PauseDialog.show()
	
func _on_Button_button_down():
	get_tree().paused = false
	$TopUI/PauseDialog.hide()

func _on_EndRound_timeout():
	get_tree().paused = true
	var label:RichTextLabel = $TopUI/PauseDialog/RichTextLabel
	get_multipliers_list(label)
	$TopUI/PauseDialog.show()
	
func get_multipliers_list(label: RichTextLabel):
	label.clear()
	label.add_text(TITLE_END_OF_DAY)
	label.newline()
	label.add_text(TITLE_MUPLIPLIERS)
	label.newline()
	for a in achievements:
		label.add_text(a.name)
		label.add_text(": ")
		label.add_text("Yes" if a.achieved == true else "No")
		if a.achieved && ! a.achieved_already:
			label.add_text(" NEW")
		label.newline()
		
