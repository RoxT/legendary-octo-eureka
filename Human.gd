extends Node2D

export var speed: int = 50
export var hours_of_sleep = 3

#Position

onready var bed_to_fridge = [$South_Point, $Fridge, $Food, $Fridge]
onready var bed_to_desk = [$Desk]
onready var bed_to_couch = [$South_Point, $To_Couch, $Couch]
onready var desk_to_fridge = [$Fridge, $Food, $Fridge]
onready var desk_to_bed = [$Bed]
onready var desk_to_couch = [$South_Point, $To_Couch, $Couch]
onready var couch_to_fridge = [$To_Couch, $South_Point, $Fridge, $Food, $Fridge]
onready var couch_to_bed = [$To_Couch, $South_Point, $Bed]
onready var couch_to_desk = [$To_Couch, $South_Point, $Desk]
onready var fridge_to_desk = [$Desk]
onready var fridge_to_couch = [$South_Point, $To_Couch, $Couch]
onready var fridge_to_bed = [$To_Couch, $Bed]

onready var activities = [$Desk, $Fridge, $Couch]
onready var timer: Timer = $Schedule

var path: Array
var path_i: int

onready var current_activity:Position2D = $Bed
var special_activity = null
var target

#Feelings

var annoyed: int = 0

#Time

const A_DAY: int = 72 #Multiples of 24 = 24, 48, 72, 96, 120
var sec_per_hour:int = A_DAY/24
const MIN_DURATION = 2
const MAX_DURATION = 4
const SPECIAL_DURATION = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	assert(A_DAY%24 == 0, "O day must be a multiple of 24")
	$EndRound.wait_time = A_DAY
	$EndRound.start()
	var seconds_to_sleep = hours_of_sleep * sec_per_hour
	$BedTime.wait_time = A_DAY - seconds_to_sleep
	$BedTime.start()
	timer.wait_time = seconds_to_sleep
	timer.start()

	$Body.position = $Bed.position
	print("Second per day: ", A_DAY, "   Sleep time (hrs): ", hours_of_sleep, " * 2")
	print("sleep timer: ", $BedTime.wait_time)
	print("hours per activity: ", MIN_DURATION, " to ", MAX_DURATION)

func _process(delta):
	if target != null:
		$Body.position = $Body.position.move_toward(target, delta * speed)
		var distance = $Body.position.distance_to(target)
		if  distance <= 1:
			update_target()

func has_time_for_cute()->bool:
	return current_activity != $Bed && current_activity != $Desk
			
func brushed_against(cat:Vector2):
	$Body/HumanSprite.distract(cat, $Body/HumanSprite.CUTE)

func meow(cat:Vector2):
	annoyed = annoyed + 1
	if annoyed == 1:
		$Body/HumanSprite.distract(cat, $Body/HumanSprite.CUTE)
	else:
		$Body/HumanSprite.distract(cat, $Body/HumanSprite.ANGRY)
	if annoyed >=3:
		special_activity = $Fridge
		$Special.wait_time = SPECIAL_DURATION * sec_per_hour
		annoyed = 0
		set_path(current_activity, special_activity)
	
func set_path(from_activity:Position2D, to_activity:Position2D):
	if from_activity == $Desk:
		if to_activity == $Fridge:
			path = desk_to_fridge
		elif to_activity == $Couch:
			path = desk_to_couch
		elif to_activity == $Bed:
			path = desk_to_bed
	
	elif from_activity == $Fridge:
		if to_activity == $Desk:
			path = fridge_to_desk
		elif to_activity == $Couch:
			path = fridge_to_couch
		elif to_activity == $Bed:
			path = fridge_to_bed
	
	elif from_activity == $Couch:
		if to_activity == $Desk:
			path = couch_to_desk
		elif to_activity == $Fridge:
			path = couch_to_fridge
		elif to_activity == $Bed:
			path = couch_to_bed
	
	elif from_activity == $Bed:
		if to_activity == $Desk:
			path = bed_to_desk
		elif to_activity == $Fridge:
			path = bed_to_fridge
		elif to_activity == $Couch:
			path = bed_to_couch
	
	path_i = 0
	target = path[0].position
	$Body/HumanSprite.turn_towards(target)
	$Body/HumanSprite.play()

func _on_Schedule_timeout():
	randomize()
	var activity = activities[randi() % activities.size()]
	var duration_sec = (randi() % (MAX_DURATION - 1) + MIN_DURATION) * sec_per_hour
	set_path(current_activity, activity)
	current_activity = activity
	timer.wait_time = duration_sec
	timer.start()
	print("chose ", activity.name, " for ", duration_sec, "s   (", duration_sec/sec_per_hour, "hrs) at ", $BedTime.time_left)
	
	
func update_target():
	path_i = path_i + 1
	if path_i > path.size()-1:
		if current_activity == $Fridge:
			$Body/HumanSprite.face($Body/HumanSprite.UP)
		elif current_activity == $Couch:
			$Body/HumanSprite.face($Body/HumanSprite.DOWN)
		elif current_activity == $Desk:
			$Body/HumanSprite.face($Body/HumanSprite.UP)
		target = null
		if special_activity != null:
			set_path(special_activity, current_activity)
			special_activity = null
		else:
			$Body/HumanSprite.stop()
	else:
		target = path[path_i].position
		$Body/HumanSprite.turn_towards(target)
	
func _on_BedTime_timeout():
	print("time for bed")
	timer.stop()
	set_path(current_activity, $Bed)

