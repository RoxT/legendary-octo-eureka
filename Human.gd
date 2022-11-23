extends Node2D

export var speed: int = 50
export var hours_of_sleep = 3

onready var bed_to_fridge = [$Bed_Fridge, $Fridge, $Food, $Fridge]
onready var bed_to_desk = [$Desk]
onready var bed_to_couch = [$Bed_Couch, $Couch]
onready var desk_to_fridge = [$Fridge, $Food, $Fridge]
onready var desk_to_bed = [$Bed]
onready var desk_to_couch = [$Couch]
onready var couch_to_fridge = [$Fridge, $Food, $Fridge]
onready var couch_to_bed = [$Bed_Couch, $Bed]
onready var couch_to_desk = [$Desk]
onready var fridge_to_desk = [$Desk]
onready var fridge_to_couch = [$Couch]
onready var fridge_to_bed = [$Bed_Fridge, $Bed]

onready var activities = [$Desk, $Fridge, $Couch]
onready var timer: Timer = $Schedule

var path: Array
var path_i: int

onready var old_activity:Position2D = $Bed
var target

const a_day: int = 72 #Multiples of 24 = 24, 48, 72, 96, 120
var sec_per_hour = a_day/24
const min_duration = 2
const max_duration = 4

# Called when the node enters the scene tree for the first time.
func _ready():
	var seconds_to_sleep = hours_of_sleep * sec_per_hour
	$BedTime.wait_time = a_day - seconds_to_sleep
	$BedTime.start()
	timer.wait_time = seconds_to_sleep
	timer.start()

	$Body.position = $Bed.position
	print("Second per day: ", a_day, "   Sleep time (hrs): ", hours_of_sleep, " * 2")
	print("sleep timer: ", $BedTime.wait_time)
	print("hours per activity: ", min_duration, " to ", max_duration)

func _process(delta):
	if target != null:
		$Body.position = $Body.position.move_toward(target, delta * speed)
		var distance = $Body.position.distance_to(target)
		if  distance <= 1:
			update_target()
			
func new_activity():
	randomize()
	var duration_sec = (randi() % (max_duration - 1) + min_duration) * sec_per_hour
	var activity = activities[randi() % activities.size()]
	print("chose ", activity.name, " for ", duration_sec, "s   (", duration_sec/sec_per_hour, "hrs) at ", $BedTime.time_left)
	
	if old_activity == $Desk:
		if activity == $Fridge:
			path = desk_to_fridge
		elif activity == $Couch:
			path = desk_to_couch
	
	elif old_activity == $Fridge:
		if activity == $Desk:
			path = fridge_to_desk
		elif activity == $Couch:
			path = fridge_to_couch
	
	elif old_activity == $Couch:
		if activity == $Desk:
			path = couch_to_desk
		elif activity == $Fridge:
			path = couch_to_fridge
	
	elif old_activity == $Bed:
		if activity == $Desk:
			path = bed_to_desk
		elif activity == $Fridge:
			path = bed_to_fridge
		elif activity == $Couch:
			path = bed_to_couch
	
	old_activity = activity
	path_i = 0
	target = path[0].position
	timer.wait_time = duration_sec
	timer.start()

func _on_Schedule_timeout():
	new_activity()
	
func update_target():
	path_i = path_i + 1
	if path_i > path.size()-1:
		target = null
	else:
		target = path[path_i].position
	
func _on_BedTime_timeout():
	print("time for bed")
	timer.stop()
	if old_activity == $Desk:
		path = desk_to_bed
	elif old_activity == $Couch:
		path = couch_to_bed
	elif old_activity == $Fridge:
		path = fridge_to_bed
	
	path_i = 0
	target = path[0].position
