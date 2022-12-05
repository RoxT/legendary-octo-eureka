extends Node2D

const DEFAULT = "default"
const MAIN_MENU_SCENE = "res://MainMenu.tscn"
onready var hungerNode = $HUD/Hunger
onready var energyNode = $HUD/Energy

const TITLE_MUPLIPLIERS = "Multipliers this Round:"
const TITLE_END_OF_DAY = "End of Day"
const NO_ACHIEVEMENTS = "No multipliers achieved today"

const PAWS_SUBTITLE = "Multipliers achieved:"

var score: int
var sleeping: bool = false

const default_multiplier = 10.0
const CAT = "PlayerCat"

const BALL_DRAIN = 50

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
var brushed_against: Achievement

var config
const FILE_NAME = "user://configs.cfg"
const SECTION_ACHIEVEMENTS = "achievements"
const SECTION_SCORING = "scoring"
const HIGH_SCORE = "high_score"
const TOTAL_SCORE = "total_score"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	slept_on_bed = Achievement.new("slept_on_bed", 0.2)
	achievements.append(slept_on_bed)
	played_with_ball = Achievement.new("played_with_ball", 0.2)
	achievements.append(played_with_ball)
	brushed_against = Achievement.new("brushed_against", 0.2)
	achievements.append(brushed_against)
	score = 0;
	config = ConfigFile.new()
	var err = config.load(FILE_NAME)
	if err != OK:
		print(err)
	played_with_ball.achieved_already = config.get_value(SECTION_ACHIEVEMENTS, played_with_ball.name, false)
	slept_on_bed.achieved_already = config.get_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, false)
	brushed_against.achieved_already = config.get_value(SECTION_ACHIEVEMENTS, brushed_against.name, false)
	$HUD/ScoreLabel.text = str(score)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _process(_delta):
	if sleeping:
		var modifiers = 1
		modifiers = modifiers + (slept_on_bed.multiplier if slept_on_bed.active else 0.0)
		modifiers = modifiers + (played_with_ball.multiplier if played_with_ball.active else 0.0)
		modifiers = modifiers + (brushed_against.multiplier if brushed_against.active else 0.0)
		score = score + default_multiplier * modifiers
		$HUD/ScoreLabel.text = str(score)
		$HUD/ModifierLabel.text = "x" + str(modifiers) + ("!" if modifiers > 1 else "")


func _on_Food_body_entered(body):
	if body.name == "PlayerCat":
		
		if $Food/AnimatedSprite.frame == $Food.FOOD_FULL:
			hungerNode.eat()
			$Food.empty()
			$PlayerCat.eat()

func _on_Sleep_pressed():
	$PlayerCat.sleep_toggle()

func _on_PlayerCat_cat_sleep():
	if (hungerNode.value <= 0):
		$PlayerCat.sleep_toggle()
	else:
		sleeping = true
		energyNode.sleep()
		if slept_on_bed.active:
			slept_on_bed.achieved = true
		if played_with_ball.active:
			played_with_ball.achieved = true
		if brushed_against.active:
			brushed_against.achieved = true
		

func _on_PlayerCat_cat_wake():
	sleeping = false
	energyNode.wake()
	played_with_ball.active = false
	brushed_against.active = false

func _on_Energy_fully_napped():
	if sleeping:
		$PlayerCat.sleep_toggle()

func _on_Hunger_too_hungry():
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
		energyNode.drain(BALL_DRAIN)

func _on_Human_Body_body_entered(body):
	if body.name == CAT && $HumanLife.has_time_for_cute():
		brushed_against.active = true
		$HumanLife.brushed_against(body.position)

func _on_Meow_pressed():
	$PlayerCat.meow()
	$HumanLife.meow($PlayerCat.position)

func _on_PawsBtn_pressed():
	get_tree().paused = true
	var label:RichTextLabel = $TopUI/PauseDialog/PawsLabel
	label.clear()
	label.add_text(PAWS_SUBTITLE)
	label.newline()
	for a in achievements:
		label.add_text("	" + a.name)
		label.add_text((" x" + str(a.multiplier)) if a.achieved == true else "	NO")
		label.newline()
	$TopUI/PauseDialog.show()
	$HUD.position.y = 128
	
func _on_Button_button_down():
	get_tree().paused = false
	$TopUI/PauseDialog.hide()
	$HUD.position.y = 0

func _on_ResetBtn_button_down():
	get_tree().paused = false
	var err = get_tree().change_scene(MAIN_MENU_SCENE)
	if err != OK:
		print(err)

func _on_EndRound_timeout():
	config.set_value(SECTION_ACHIEVEMENTS, slept_on_bed.name, slept_on_bed.achieved)
	config.set_value(SECTION_ACHIEVEMENTS, played_with_ball.name, played_with_ball.achieved)
	config.set_value(SECTION_ACHIEVEMENTS, brushed_against.name, brushed_against.achieved)
	
	config.get_value(SECTION_SCORING, HIGH_SCORE, 0)
	var high_score_text = ""
	var high_score = config.get_value(SECTION_SCORING, HIGH_SCORE, 0)
	if score > high_score:
		high_score_text = "NEW HIGH SCORE: " + str(score)
		config.set_value(SECTION_SCORING, HIGH_SCORE, score)
	else: high_score_text = "High Score to beat: " + str(high_score)
	
	var total_score = config.get_value(SECTION_SCORING, TOTAL_SCORE, 0) + score
	config.set_value(SECTION_SCORING, TOTAL_SCORE, total_score)
	var total_score_text = "Total Points Gathered: " + str(total_score)
	
	config.save(FILE_NAME)
		
	get_tree().paused = true
	var label:RichTextLabel = $TopUI/PauseDialog/RichTextLabel
	get_multipliers_list(label, high_score_text, total_score_text)
	$TopUI/PauseDialog.show()
	
func get_multipliers_list(label: RichTextLabel, high_score:String, total_score:String):
	label.clear()
	label.add_text(TITLE_END_OF_DAY)
	label.newline()
	label.add_text(TITLE_MUPLIPLIERS)
	label.newline()
	if achievements.empty():
		label.add_text(NO_ACHIEVEMENTS)
		label.newline()
	for a in achievements:
		label.add_text(a.name)
		label.add_text(": ")
		label.add_text("Yes" if a.achieved == true else "No")
		if a.achieved && ! a.achieved_already:
			label.add_text(" NEW")
		label.newline()
	label.add_text(high_score)
	label.newline()
	label.add_text(total_score)
