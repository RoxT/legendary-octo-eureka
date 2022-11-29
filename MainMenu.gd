extends Control

const MAIN_SCENE_PATH = "res://Main.tscn"

const TITLE_MULTIPLIERS = "Multipliers Discovered"

onready var items = $Items.get_children()
var index: int = 0
onready var arrow = $Arrow

var config
const FILE_NAME = "user://configs.cfg"
const SECTION_ACHIEVEMENTS = "achievements"

# Called when the node enters the scene tree for the first time.
func _ready():
	remove_child(arrow)
	items[0].add_child(arrow)
	config = ConfigFile.new()
	var err = config.load(FILE_NAME)
	if err != OK:
		print(err)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_up"):
		items[index].remove_child(arrow)
		index = (index-1) % items.size()
		items[index].add_child(arrow)
	if Input.is_action_just_pressed("ui_down"):
		items[index].remove_child(arrow)
		index = (index+1) % items.size()
		items[index].add_child(arrow)
	if Input.is_action_just_pressed("jump"):
		if $Items.is_visible():
			match index:
				0: 
					var err = get_tree().change_scene(MAIN_SCENE_PATH)
					if err != OK:
						print(err)
				1: 
					show_achievements()
		else:
			$Achievements.visible = false
			$Items.visible = true
		

func show_achievements():
	$Items.visible = false
	var label = $Achievements
	label.clear()
	label.visible = true
	label.add_text(TITLE_MULTIPLIERS)
	label.newline()
	
	var keys = config.get_section_keys(SECTION_ACHIEVEMENTS)
	
	for key in keys:
		var achieved = config.get_value(SECTION_ACHIEVEMENTS, key, false)
		label.add_text(key)
		label.add_text(": ")
		label.add_text("Yes" if achieved == true else "No")
		label.newline()
